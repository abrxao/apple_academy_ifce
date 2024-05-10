import jsonServer from "json-server";
const server = jsonServer.create();
const router = jsonServer.router("db.json"); // your data file
const middlewares = jsonServer.defaults();

// Use default middleware (logger, static, cors and no-cache)
server.use(middlewares);

// Add custom routes before JSON Server router
server.get("/users/:id/events_details", (req, res) => {
  const userId = req.params.id; // Assuming the resource name is 'useEvents'

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  
  const userEvents = events.filter((event) =>{
    return (
      event.subscribers.includes(userId) ||
      userId === event.creatorId)}
  );

  res.jsonp(userEvents);
});

// Use default json-server routes
server.use(router);

// Start server
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log("JSON Server is running on port " + PORT);
});
