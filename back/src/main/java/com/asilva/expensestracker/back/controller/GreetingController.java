package com.asilva.expensestracker.back.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    @RequestMapping("/greeting")
    public String GreetingMessage(){
        return "Hello from expenses tracker";
    }
}
