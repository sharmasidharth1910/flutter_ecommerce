"use strict";

/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/models.html#lifecycle-hooks)
 * to customize this model
 */
module.exports = {
  // lifecycles: {
  //   beforeUpdate(params, data) {
  //     console.log("Inside the before update method");
  //     const {products} = data;
  //     console.log(products);
  // return strapi.services.cart.update(params, {
  //   products: ["abcde"],
  // });
  //   },
  // },

  lifecycles: {
    beforeUpdate: async (model, attrs, options) => {
      console.log(model);
      console.log(attrs);
      const { products } = attrs;
      console.log(products);
      // return strapi.services.cart.update(params, {
      //   products: ["abcde"],
      // });
      // console.log(options);
      // if (model.getUpdate().title) {
      //   model.update({
      //     slug: slugify(model.getUpdate().title),
      //   });
      // }
    },
  },

  // update(ctx) {
  //   const { products } = ctx.request.body;
  //   console.log("products", products);
  //   return strapi.services.cart.update(ctx.params, {
  //     products: JSON.parse(products),
  //   });
  // },

  // update: async (ctx, next) => {
  //   const { products } = ctx.request.body;
  //   return strapi.services.cart.edit(ctx.params, {
  //     products: JSON.parse(products),
  //   });
  // },
};
