package api

import cats.effect._
import org.http4s._
import org.http4s.dsl.io._
import io.circe.generic.auto._
import io.circe.syntax._
import org.http4s.circe._

object ZergService {
    val myUri: Uri = uri("/zerg")
}

class ZergService(repository: ZergRepository) {

    val helloWorldService: HttpService[IO] = HttpService[IO] {
        case GET -> Root / "hello" / name =>
            if (name.isEmpty)
                Ok("Hello world.")
            else
                Ok(s"Hello $name.")
    }

    val zergService: HttpService[IO] = HttpService[IO] {
        case GET -> Root / "zerg" / id => {
            try {
                val idInt = id.toInt

                for {
                    a <- repository.getById(idInt)
                    b <- optionToHttpResult(a)
                } yield (b)
            }
            catch {
                case _: NumberFormatException => BadRequest()
            }
        }
        case req@POST -> Root / "zerg" =>
            ???
        case DELETE -> Root / "id" =>
            ???
    }

    private def optionToHttpResult(r: Option[Zerg]) = {
        r match {
            case None => NotFound()
            case Some(x) => Ok(x.asJson)
        }
    }
}
