package api

import cats.effect._, org.http4s._, org.http4s.dsl.io._, scala.concurrent.ExecutionContext.Implicits.global

object Service {

    val helloWorldService: HttpService[IO] = HttpService[IO] {
        case GET -> Root / "hello" / name =>
            if (name.isEmpty)
                Ok("Hello world.")
            else
                Ok(s"Hello $name.")
    }
}
