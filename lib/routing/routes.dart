const rootRoute = "/";

const AllProductsPageDisplayName = "Todos Produtos";
const overviewPageRoute = "/all_products";


const driversPageDisplayName = "Pedidos";
const driversPageRoute = "/drivers";

const configPageDisplayName = "Configurações";
const configPageRoute = "/config";

const authenticationPageDisplayName = "Sair";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
 MenuItem(AllProductsPageDisplayName, overviewPageRoute),
 MenuItem(driversPageDisplayName, driversPageRoute),
  MenuItem(configPageDisplayName, configPageRoute),
 MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
