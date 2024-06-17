import jsonServer from "json-server";

const server = jsonServer.create();
const router = jsonServer.router("db.json"); // Assuming "db.json" is your data file
const middlewares = jsonServer.defaults();

// Use default middleware (logger, static, cors, and no-cache)
server.use(middlewares);

// Custom routes
server.use(jsonServer.bodyParser);

// Get user's events //METODOS DE REQUISIÇÃO - GET - POST - PUT - PATCH - DELETE
server.get("/users/:id/events_details", (req, res) => {
  const userId = req.params.id; // Parse the ID as an integer

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  const userEvents = events.filter(
    (event) => event.subscribers.includes(userId) || userId === event.creatorId
  );

  res.status(200).json(userEvents);
});

// Get user's events
server.get("/events/:id/subscribers_details", (req, res) => {
  const eventID = req.params.id; // Parse the ID as an integer

  const events = router.db
    .get("events")
    .value()
    .filter((event) => event.id == eventID); // Assuming the resource name is 'events'
  const subscribers = events[0].subscribers;
  const subscribers_details = router.db
    .get("users")
    .value()
    .filter((user) => subscribers.includes(user.id));
  // Filter the data based on the array of IDs
  res.status(200).json(subscribers_details);
});

// Get local's events
server.get("/locals/:id/events_details", (req, res) => {
  const localId = req.params.id; // Parse the ID as an integer

  const events = router.db.get("events").value(); // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  const localEvents = events.filter((event) => localId === event.localID);

  res.status(200).json(localEvents);
});

server.get("/locals_with_events", (req, res) => {
  // Parse the ID as an integer
  const locals = router.db.get("locals").value();
  const events = router.db.get("events").value();
  const eventsID = events.map((event) => event.localID)
  // Assuming the resource name is 'events'
  // Filter the data based on the array of IDs
  const localFiltered = locals.filter((local) => eventsID.includes(local.id));

  res.status(200).json(localFiltered);
});

server.post("/events/:id/toggleSubscription", (req, res) => {
  const eventId = req.params.id;
  const userId = req.body.userId;
  const events = router.db.get("events").value();
  const event = events.find((event) => event.id === eventId);

  if (!event) {
    return res.status(404).send({ error: "Event not found" });
  }

  const subscribers = event.subscribers;
  const index = subscribers.indexOf(userId);

  if (index === -1) {
    // User not subscribed, add them
    subscribers.push(userId);
  } else {
    // User already subscribed, remove them
    subscribers.splice(index, 1);
  }
  // Update the event in the database
  router.db.get("events").find({ id: eventId }).assign({ subscribers }).write();

  res.send(subscribers);
});
// Use default json-server routes

server.post("/events/:id/remove_sub", (req, res) => {
  const eventId = req.params.id;
  const userId = req.body.userId;
  const events = router.db.get("events").value();
  const event = events.find((event) => event.id === eventId);

  if (!event) {
    return res.status(404).send({ error: "Event not found" });
  }

  const subscribers = event.subscribers;
  const index = subscribers.indexOf(userId);

  if (index === -1) {
    // User not subscribed, add them
    return res.status(404).send({ error: "User not inscribed" });
  } else {
    // User already subscribed, remove them
    subscribers.splice(index, 1);
  }
  // Update the event in the database
  router.db.get("events").find({ id: eventId }).assign({ subscribers }).write();

  res.send(subscribers);
});
server.use(router);

// Start server
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log("JSON Server is running on port " + PORT);
});
