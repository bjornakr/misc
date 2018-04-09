val http4sVersion = "0.18.7"
val doobieVersion = "0.5.2"
val circeVersion = "0.9.3"

lazy val root = (project in file(".")).
    settings(
        inThisBuild(List(
            organization := "io.github.bjornakr",
            scalaVersion := "2.12.4",
            version := "0.1.0-SNAPSHOT"
        )),

        name := "test04",

        libraryDependencies ++= Seq(
            "org.http4s" %% "http4s-dsl",
            "org.http4s" %% "http4s-blaze-server",
            "org.http4s" %% "http4s-blaze-client",
            "org.http4s" %% "http4s-circe",
        ).map(_ % http4sVersion),

        libraryDependencies ++= Seq(
            // Optional for auto-derivation of JSON codecs
//            "io.circe" %% "circe-generic" % circeVersion,
            // Optional for string interpolation to JSON model
//            "io.circe" %% "circe-literal" % circeVersion
        ),

        libraryDependencies ++= Seq(
            "org.tpolecat" %% "doobie-core",
            "org.tpolecat" %% "doobie-postgres", // Postgres driver 42.2.2 + type mappings.
            "org.tpolecat" %% "doobie-scalatest" // ScalaTest support for typechecking statements.
        ).map(_ % doobieVersion),

        libraryDependencies ++= Seq(
            "io.circe" %% "circe-core",
            "io.circe" %% "circe-generic",
            "io.circe" %% "circe-literal",
            "io.circe" %% "circe-parser"
        ).map(_ % circeVersion),

        libraryDependencies += "ch.qos.logback" % "logback-classic" % "1.2.3",

        libraryDependencies += "org.scalatest" %% "scalatest" % "3.0.5" % Test,
        libraryDependencies += "org.scalamock" %% "scalamock" % "4.1.0" % Test,

        scalacOptions ++= Seq("-Ypartial-unification")
    )

enablePlugins(FlywayPlugin)
name := "plugtest"
version := "0.0.1"
name := "flyway-sbt-test1"

libraryDependencies += "org.hsqldb" % "hsqldb" % "2.2.8"

flywayUrl := "jdbc:postgresql://localhost:65432/test04_db"
flywayUser := "developer"
flywayPassword := "testpassword"
flywayLocations += "db/migration"
//flywayUrl in Test := "jdbc:hsqldb:file:target/flyway_sample;shutdown=true"
//flywayUser in Test := "SA"
