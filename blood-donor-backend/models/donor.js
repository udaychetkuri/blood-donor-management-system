module.exports = (sequelize, DataTypes) => {
    const Donor = sequelize.define('Donor', {
      name: DataTypes.STRING,
      age: DataTypes.INTEGER,
      bloodGroup: DataTypes.STRING,
      contact: DataTypes.STRING,
      city: DataTypes.STRING,
      email: {
        type: DataTypes.STRING,
        unique: true,
        allowNull: false,
      },
    });
  
    return Donor;
  };
  