import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
        System.setProperty("karate.outputHtmlDir", "karate-reports");
    }
    
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:karate-test.feature")
                .outputHtmlReport(true)
                .outputCucumberJson(true)
                .reportDir("karate-reports");
    }
}
