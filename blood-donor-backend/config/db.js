const { Sequelize } = require('sequelize');

// Create a new Sequelize instance connected to a SQLite file
const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: './blood_donor.sqlite', // database file path
  logging: false, // set to true if you want SQL logs in console
});

module.exports = sequelize;
