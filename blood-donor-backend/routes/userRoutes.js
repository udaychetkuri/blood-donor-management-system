// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const { User } = require('../models/User');

router.post('/login', async (req, res) => {
  const { name, email } = req.body;

  try {
    const user = await User.findOne({ where: { name, email } });

    if (!user) {
      return res.status(401).json({ message: 'Invalid name or email' });
    }

    res.status(200).json({
      message: 'Login successful',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        bloodGroup: user.bloodGroup,
        city: user.city,
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
