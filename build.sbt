import org.openurp.parent.Dependencies._
import org.openurp.parent.Settings._

ThisBuild / organization := "org.openurp.prac.activity"
ThisBuild / version := "0.0.1-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/prac-activity"),
    "scm:git@github.com:openurp/prac-activity.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "The OpenURP Prac Activity"
ThisBuild / homepage := Some(url("http://openurp.github.io/prac-activity/index.html"))
ThisBuild / resolvers += Resolver.mavenLocal

val apiVer = "0.25.1"
val starterVer = "0.0.20"
val baseVer = "0.1.29"
val openurp_base_api = "org.openurp.base" % "openurp-base-api" % apiVer
val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_stater_ws = "org.openurp.starter" % "openurp-starter-ws" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
lazy val root = (project in file("."))
  .settings()
  .aggregate(web, webapp)

lazy val web = (project in file("web"))
  .settings(
    name := "openurp-prac-activity-web",
    common,
    libraryDependencies ++= Seq(beangle_webmvc_support, beangle_data_orm, beangle_ems_app),
    libraryDependencies ++= Seq(openurp_base_api, openurp_stater_web, openurp_base_tag),
    libraryDependencies ++= Seq(beangle_serializer_text, openurp_edu_api)
  )
lazy val webapp = (project in file("webapp"))
  .enablePlugins(WarPlugin, UndertowPlugin, TomcatPlugin)
  .settings(
    name := "openurp-prac-activity-webapp",
    common,
    libraryDependencies ++= Seq(logback_classic, ehcache, hibernate_jcache)
  ).dependsOn(web)

publish / skip := true
