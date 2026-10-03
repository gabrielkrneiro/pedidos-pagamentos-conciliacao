package com.payflow.payments;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@SpringBootTest
@Import(TestcontainersConfiguration.class)
class PaymentsApiApplicationTests {

  @Test
  void contextLoads() {
  }

}
