angular.module("Shop").controller "ProductsCtrl", ($scope, $rootScope, Product, OrderCycle) ->
  $scope.data = Product.data
  $scope.order_cycle = OrderCycle.order_cycle
  Product.update()

  $scope.productPrice = (product) ->
    if product.variants.length > 0
      prices = (v.price for v in product.variants)
      Math.min.apply(null, prices)
    else
      product.price
