angular.module "12307App" .factory 'Menu', ($rootScope)->
  logged-out-menu = [title: '首页', link: '/']
  logged-in-menu = logged-out-menu.concat items =
    * title: '车票预订'
      link: '/tickets'
    * title: '用户设置'
      link: '/settings'
  service =
    get-menu: -> if $rootScope.currentUser then logged-in-menu else logged-out-menu
