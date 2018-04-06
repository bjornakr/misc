import Dependencies._


val http4sVersion = "0.18.7"

lazy val root = (project in file(".")).
    settings(
        inThisBuild(List(
            organization := "io.github.bjornakr",
            scalaVersion := "2.12.4",
            version := "0.1.0-SNAPSHOT"
        )),

        name := "test04",

        libraryDependencies ++= Seq(
            "org.http4s" %% "http4s-dsl" % http4sVersion,
            "org.http4s" %% "http4s-blaze-server" % http4sVersion,
            "org.http4s" %% "http4s-blaze-client" % http4sVersion
        ),

        libraryDependencies += "ch.qos.logback" % "logback-classic" % "1.2.3",

        libraryDependencies += scalaTest % Test,

        scalacOptions ++= Seq("-Ypartial-unification")

    )
