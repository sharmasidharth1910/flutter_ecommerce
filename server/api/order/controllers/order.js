"use strict";

const stripe = require("stripe")(
  "sk_test_51HQQNzAHq1q1hh4yKWHe7O3aw8R2oZGAmgC3qJdaFeHPOgdZ4K2PLihXV2h4PDzJVxbovkajcVJw1ZkbvdOI8XJ300vNw0Vaxe"
);
const { v4: uuidv4 } = require("uuid");

/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
  async create(ctx) {
    const { amount, products, customer, source } = ctx.request.body;
    const { email } = ctx.state.user;

    const charge = {
      amount: parseInt(amount) * 100,
      currency: "inr",
      customer,
      source,
      receipt_email: email,
    };

    const idempotencykey = uuidv4();

    await stripe.charges.create(charge, {
      idempotencyKey: idempotencykey,
    });

    return strapi.services.order.create({
      amount,
      products: JSON.parse(products),
      user: ctx.state.user,
    });
  },
};
