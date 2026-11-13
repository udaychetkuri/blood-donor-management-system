const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../models');
const User = db.User;
const Admin = db.Admin;

const JWT_SECRET = process.env.JWT_SECRET;

// User Register
exports.registerUser = async (req, res) => {
  const { name, email, password } = req.body;
  try {
    const hashed = await bcrypt.hash(password, 10);
    const newUser = await User.create({ name, email, password: hashed });
    res.status(201).json({ message: 'User registered', user: newUser });
  } catch (err) {
    res.status(400).json({ error: 'Registration failed', details: err });
  }
};

// User Login
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ where: { email } });
    if (!user || !(await bcrypt.compare(password, user.password)))
      return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ id: user.id, type: 'user' }, JWT_SECRET);
    res.json({ token, user });
  } catch (err) {
    res.status(500).json({ error: 'Login error', details: err });
  }
};

// Admin Login
exports.loginAdmin = async (req, res) => {
  const { username, password } = req.body;
  try {
    const admin = await Admin.findOne({ where: { username } });
    if (!admin || !(await bcrypt.compare(password, admin.password)))
      return res.status(401).json({ error: 'Invalid admin credentials' });

    const token = jwt.sign({ id: admin.id, type: 'admin' }, JWT_SECRET);
    res.json({ token, admin });
  } catch (err) {
    res.status(500).json({ error: 'Admin login error', details: err });
  }
};
