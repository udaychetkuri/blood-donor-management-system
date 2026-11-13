
const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: './blood_donor.sqlite',
  logging: false
});
const User = require('./user')(sequelize, DataTypes);  // Initializes the User model

// Add more models here if needed in the future

const db = {
  sequelize,
  Sequelize,
  User,  // Export the User model
};

module.exports = db;
