
import io.prometheus.client.{CollectorRegistry, Gauge}
import io.prometheus.client.exporter.PushGateway

object Main {
    def main(args: Array[String]): Unit = {
        val pushGateway : PushGateway =
            new PushGateway(s"localhost:9100")
        val registry = new CollectorRegistry

        val dummyGauge = Gauge
            .build()
            .name("the_answer")
            .help("""The answer to life,
             the universe and everything""")
            .register(registry)

        dummyGauge.set(42)
        
        pushGateway.push(registry, "devops")
    }
}

libraryDependencies ++= Seq(

  "io.prometheus" % "simpleclient" % "0.1.0",
  "io.prometheus" % "simpleclient_common" % "0.1.0",
  "io.prometheus" % "simpleclient_hotspot" % "0.1.0",
  "io.prometheus" % "simpleclient_pushgateway" % "0.1.0",
)