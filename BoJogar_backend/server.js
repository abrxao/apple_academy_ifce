import jsonServer from "json-server";
const server = jsonServer.create();
const router = jsonServer.router("db.json"); // your data file
const middlewares = jsonServer.defaults();

// Use default middleware (logger, static, cors and no-cache)
server.use(middlewares);

// Add custom routes before JSON Server router
server.get("/events-by-subscriber/:userId", (req, res) => {
  const userId = req.params.userId;
  const db = router.db; // Get lowdb database
  const events = db
    .get("events")
    .filter((event) => event.subscribers.includes(userId))
    .value();
  res.jsonp(events);
});

// Use default json-server routes
server.use(router);

// Start server
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log("JSON Server is running on port " + PORT);
});
