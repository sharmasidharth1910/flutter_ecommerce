"use strict";

const stripe = require("stripe")(
  "sk_test_51HQQNzAHq1q1hh4yKWHe7O3aw8R2oZGAmgC3qJdaFeHPOgdZ4K2PLihXV2h4PDzJVxbovkajcVJw1ZkbvdOI8XJ300vNw0Vaxe"
);
const uuid = require("uuid/v4");

/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
  lifecycles: {},
};
