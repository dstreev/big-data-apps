//import sbtunidoc.Plugin.unidocSettings

name := "spark-scala"

version in ThisBuild := "0.0.1"

scalaVersion in ThisBuild := "2.11.12"

//testOptions in ThisBuild += Tests.Argument(TestFrameworks.ScalaTest, "-h", "target/test-reports")

//unidocSettings

libraryDependencies in ThisBuild ++= Seq(
  "org.scalatest" %% "scalatest" % "2.1.7" % "test",
  "org.pegdown" % "pegdown" % "1.4.2" % "test",      // (For Html Scalatest reports)
  "org.apache.spark" %% "spark-core" % "2.3.2"
)

lazy val commonSettings = Seq(
  target := { baseDirectory.value / "target" }
)

lazy val root = (project in file("."))
  .settings(
    name := "Spark-Scala",
    commonSettings
  )

lazy val common = (project in file("common"))
  .settings(
  	name := "common",
  	commonSettings
  )


lazy val airlines = project
  .settings(
  	name := "airlines",
  	commonSettings
  )
