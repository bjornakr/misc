package api

import doobie._
import doobie.implicits._
import cats._
import cats.effect._
import cats.implicits._
import doobie.util.transactor.Transactor.Aux

case class Zerg(id: Int, name: String, type0: String, health: Int)

class ZergRepository {

    val xa: Aux[IO, Unit] = Transactor.fromDriverManager[IO](
        "org.postgresql.Driver", // driver classname
        "jdbc:postgresql://localhost:65432/test04_db", // connect URL (driver-specific)
        "developer", // user
        "testpassword" // password
    )

    val getAll = sql"SELECT * FROM zerg"
        .query[Zerg]
        .to[List]
        .transact(xa)

    def getById(id: Int): IO[Option[Zerg]] =
        sql"SELECT * FROM zerg WHERE id = $id"
            .query[Zerg]
            .option
            .transact(xa)

    def create(zerg: Zerg): IO[Int] =
        sql"INSERT INTO zerg (name, type, health) VALUES (${zerg.name}, ${zerg.type0}, ${zerg.health})"
            .update
            .withUniqueGeneratedKeys[Int]("id")
            .transact(xa)


}
