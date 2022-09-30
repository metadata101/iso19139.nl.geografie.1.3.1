# iso19139.nl.geografie.1.3.1

> Since this profile is only used in the Netherlands, and most users are more familiar in Dutch, this documentation is in Dutch only.

Welkom op de hub voor de Nederlandse schema profielen. Het betreft schema-plugins die as-is in [geonetwork-opensource](http://geonetwork-opensource.org) geladen kunnen worden om de support voor [Nerderlands profiel metadata](http://www.geonovum.nl/wegwijzer/standaarden/nederlands-metadataprofiel-op-iso-19115-geografie-131) te faciliteren. Maar gezien hun generieke xml opzet kunnen ze ook gebruikt worden om Nederlandse profiel support te faciliteren in andere producten.

Bekijk de [wiki](../../wiki) of [issues](../../issues) voor meer informatie.

## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 4.2.

### Adding the plugin to the source code


The best approach is to add the plugin as a submodule:

1. Use [add-schema.sh](https://github.com/geonetwork/core-geonetwork/blob/4.2.x/add-schema.sh) for automatic deployment:

   ```
   ./add-schema.sh iso19139.nl.geografie.1.3.1 https://github.com/metadata101/iso19139.nl.geografie.1.3.1 4.2.x
   ```

2. Build the application:

   ```
   mvn clean install -Penv-prod -DskipTests
   ```

3. Once the application is built, the war file contains the schema plugin:

   ```
   cd web
   mvn jetty:run -Penv-dev
   ```

### Deploy the profile in an existing installation

After building the application, it's possible to deploy the schema plugin manually in an existing GeoNetwork installation:

- Copy the content of the folder schemas/iso19139.nl.geografie.2.0.0/src/main/plugin to INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.nl.geografie.1.3.1

- Copy the jar file schemas/iso19139.nl.geografie.1.3.1/target/schema-iso19139.nl.geografie.1.3.1-4.2.2-SNAPSHOT.jar to INSTALL_DIR/geonetwork/WEB-INF/lib.

If there's no changes to the profile Java code or the configuration (config-spring-geonetwork.xml), the jar file is not required to be deployed each time.
