// Entry point for the build script in your package.json
var componentRequireContext = require.context("./components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

import "./controllers"