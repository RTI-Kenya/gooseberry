// Generated by CoffeeScript 1.9.0
var Gooseberry;

Gooseberry = {
  config: {
    database: "gooseberry",
    logDatabase: "gooseberry-log"
  },
  view: function(options) {
    return $.couch.db(Gooseberry.config.database).view(Gooseberry.config.designDoc + "/" + options.name, options);
  },
  viewLogDB: function(options) {
    return $.couch.db(Gooseberry.config.logDatabase).view(Gooseberry.config.designDoc + "/" + options.name, options);
  }
};

Gooseberry.save = function(options) {
  return $.couch.db(Gooseberry.config.database).saveDoc(options.doc, options);
};

$.couch.db(Gooseberry.config.database).openDoc("config", {
  success: function(result) {
    Gooseberry.config = _(Gooseberry.config).extend(result);
    Gooseberry.router = new Router();
    Backbone.couch_connector.config.db_name = Gooseberry.config.database;
    Backbone.couch_connector.config.ddoc_name = Gooseberry.config.designDoc;
    Backbone.couch_connector.config.global_changes = true;
    return Backbone.history.start();
  }
});

Gooseberry.debug = function(string) {
  console.log(string);
  return $("#log").append(string + "<br/>");
};

//# sourceMappingURL=Gooseberry.js.map
