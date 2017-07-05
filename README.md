# Ace

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# Learn more
  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Neo4j
1. Install Neo4j 3.1.1 (it's better to install 3.1.1 but - in my case 3.1.4 just work fine..)
2. Install Spatial plugin for 3.1.1: https://github.com/neo4j-contrib/m2/blob/master/releases/org/neo4j/neo4j-spatial/0.24-neo4j-3.1.1/neo4j-spatial-0.24-neo4j-3.1.1-server-plugin.jar.
(in Ubuntu copy .jar file to /var/lib/neo4j/plugins)
3. Configure it with whatever you want to make Neo4j Admin work on internet.. e.g: `188.166.227.144:7575`
* note: make sure to check `Do not use Bolt` on Neo4j Admin if connecting from internet to VPS's Neo4j instance.
4. Under server management (localhost:7474) => run:
```
CALL spatial.addPointLayer('geom');
CALL spatial.layers();
```
- it should return `layers` with => name | signature 
5. Add Unique constrains
```
CREATE CONSTRAINT ON (a:Account) ASSERT a.username IS UNIQUE
CREATE CONSTRAINT ON (j:JobCategory) ASSERT j.title IS UNIQUE
```
6. Seed category:
```
CREATE (j:JobCategory {title: 'Tour guide', enabled: true})
CREATE (j:JobCategory {title: 'Transportation', enabled: true})
CREATE (j:JobCategory {title: 'Shopping', enabled: true})
```