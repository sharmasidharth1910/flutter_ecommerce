"use strict";

const stripe = require("stripe")(
  "sk_test_51HQQNzAHq1q1hh4yKWHe7O3aw8R2oZGAmgC3qJdaFeHPOgdZ4K2PLihXV2h4PDzJVxbovkajcVJw1ZkbvdOI8XJ300vNw0Vaxe"
);

/**
 * A set of functions called "actions" for `card`
 */

module.exports = {
  index: async (ctx) => {
    const i = ctx.req.url.indexOf("?");
    const customerId = ctx.req.url.slice(i + 1, ctx.req.url.length);
    const customerData = await stripe.customers.listSources(customerId, {
      object: "card",
      limit: 10,
    });
    // const cardData = customerData.sources.data;
    ctx.send(customerData.data);
  },

  add: async (ctx) => {
    const { customer, source } = ctx.request.body;
    console.log("Customer Id " + customer);
    console.log("Source " + source);
    const card = await stripe.customers.createSource(customer, {
      source: source,
    });
    console.log(card);
    ctx.send(card);
  },
};
