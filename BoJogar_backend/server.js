import jsonServer from "json-server";
const server = jsonServer.create();
const router = jsonServer.router("db.json"); // your data file
const middlewares = jsonServer.defaults();

// Use default middleware (logger, static, cors and no-cache)
server.use(middlewares);

// Add custom routes before JSON Server router
server.post("/users/:id/events_details", (req, res) => {
  const userEventsIds = router.db
    .get("users")
    .value()
    .filter((user) => user.id === req.params.id)[0].events; // Assuming the resource name is 'useEvents'

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'

  // Filter the data based on the array of IDs
  const filteredData = events.filter((item) =>
    userEventsIds.includes(item.id.toString())
  );

  res.jsonp(filteredData);
});

// Use default json-server routes
server.use(router);

// Start server
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log("JSON Server is running on port " + PORT);
});
