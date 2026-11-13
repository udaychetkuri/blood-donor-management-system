// server.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./models');  // Import models

const app = express();
app.use(bodyParser.json());
app.use(cors());
// Root route (health check)
app.get("/", (req, res) => {
  res.send("Blood Donor Backend is running 🚀");
});

// ====================================
// 🚀 Routes
// ====================================

// 1. Register (Create User)
// 1. Register (Create User)
app.post('/api/users', async (req, res) => {
  try {
    const { name, email, password, bloodGroup, phone, city } = req.body;

    const newUser = await db.User.create({ name, email, password, bloodGroup, phone, city });
    res.status(201).json(newUser);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error creating user' });
  }
});

// 2. Login (User Authentication)
app.post('/api/users/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await db.User.findOne({ where: { email } });

    if (!user) {
      return res.status(400).json({ message: 'Invalid email' });
    }

    if (user.password !== password) {
      return res.status(400).json({ message: 'Invalid password' });
    }

    res.json({ message: 'Login successful', user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Login error' });
  }
});

// 3. (Optional) Get all users (for admin dashboard)
app.get('/api/users', async (req, res) => {
  try {
    const users = await db.User.findAll();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching users' });
  }
});

// ====================================
// 🚀 Server + Database Connection
// ====================================
db.sequelize.sync().then(() => {
  app.listen(3000, () => {
    console.log('✅ Server is running on http://localhost:3000');
  });
});
