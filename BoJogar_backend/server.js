import jsonServer from "json-server";

const server = jsonServer.create();
const router = jsonServer.router("db.json"); // Assuming "db.json" is your data file
const middlewares = jsonServer.defaults();
jsonServer

// Use default middleware (logger, static, cors, and no-cache)
server.use(middlewares);

// Custom routes
server.use(jsonServer.bodyParser);

// Get user's events
server.get("/users/:id/events_details", (req, res) => {
  const userId = req.params.id; // Parse the ID as an integer

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  const userEvents = events.filter((event) =>
    event.subscribers.includes(userId) || userId === event.creatorId
  );
  
  res.status(200).json(userEvents);
});

// Get local's events
server.get("/locals/:id/events_details", (req, res) => {
  const localId = req.params.id; // Parse the ID as an integer

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  const localEvents = events.filter((event) =>
    localId === event.localID
  );

  res.status(200).json(localEvents);
});

// Use default json-server routes
server.use(router);

// Start server
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log("JSON Server is running on port " + PORT);
});
