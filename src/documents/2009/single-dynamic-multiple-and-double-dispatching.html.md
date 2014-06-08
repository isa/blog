---
title: "Single, Dynamic, Multiple and Double Dispatching"
layout: "post"
isPost: true
date: "12-07-2009"
headline: "machine8.png"
urls:
   - /2009/single-dynamic-multiple-and-double-dispatching
   - /2009/development/java/single-dynamic-multiple-and-double-dispatching
tags:
   - java
   - methods
   - type-system
   - stack
   - jvm
   - programming
---

# Single, Dynamic, Multiple and Double Dispatching

## Today I was reading couple articles about programming languages and I noticed that there is still some confusion about dispatching. So I'll try to explain as much as I can. Everbody is welcome to correct!

### What is Dispatching?

Method dispatching is basically an algorithm used to decide which method should be invoked in response to a certain message. Languages have different implementations and techniques to do method dispatching. But, that's the basic explanation of it. If you are curious you can #wiki for more details. There are 3 types of dispatching mechanism:

* Single/Dynamic Dispatching
* Multiple Dispatching
* Double Dispatching

You might also find 2 other topics related to this subject, but I’m not gonna cover them today: **Monkey Patching** and **Duck Typing**. Anyways, so let’s get back to our subject:

### Single/Dynamic Dispatching

Although there is a subtle difference between them, I covered these 2 topics under the same title. So basically, when you invoke a function on a type, it’s called single dispatch as in:

```java
class Messenger {
   public void send(String message) { }
}

Messenger messenger = new Messenger();
messenger.send("Hello World");
```

If there is no polymorphic structure, compiler knows this at compile time. There can be multiple send functions under different types (classes). Compiler binds them to the correct ones in the compile time:

```java
class Messenger {
   public void send(String message) { }
}

class SMSGateway {
   public void send(String sms) { }
}

Messenger messenger = new Messenger();
messenger.send("Hello World");

SMSGateway gateway = new SMSGateway();
gateway.send("Cya in 10!");
```

In above example, compiler bound *send(message)* to *Messenger* and *send(sms)* to *SMSGateway* types. These are all single dispatch examples. No dynamic dispatching needed so far. However, if you have a polymorphic structure as in:

```java
interface Messenger {
   void send(String message);
}
class TextMessenger implements Messenger {
   public void send(String message) {
      System.out.println("TEXT: " + message);
   }
}
class XMLMessenger implements Messenger {
   public void send(String message) {
      System.out.println("<message>" + message + "</message>");
   }
}
class Demo {
   public void useMessenger(Messenger messenger) {
      messenger.send("Which messenger am I using?");
   }
}
```

As you may quickly notice, this requires dynamic dispatching (run-time decision) since compiler cannot decide the actual type of the messenger which Demo.useMessenger uses. Lots of known design patterns are already based on this mechanism (Strategy, Bridge, etc..). Again I'm not going go into details, you can find more information about this on **Single/Dynamic Dispatch**, **Single Dispatch** and **Dynamic Dispatch**.

### Multiple Dispatching

Roughly it is the idea behind overloading in most programming languages. Your type has so many functions with the same name, but they all have different parameters.

```java
class Messenger {
   public void send(String message) { }
   public void send(String message, Person to) { }
   public void send(String message, String subject, Person to) { }
}
```

You can figure out how it would work. However multiple dispatching is not just about this. I guess overloading example is misleading too. Anyways, let's consider following example:

```java
interface Messenger {
   void send(String message);
}
class TextMessenger implements Messenger {
   public void send(String message) {
      System.out.println("TEXT: " + message);
   }
}
class XMLMessenger implements Messenger {
   public void send(String message) {
      System.out.println("<message>" + message + "</message>");
   }
}
class Demo {
   public void useMessenger(Messenger messenger) {
      messenger.send("Which messenger am I using?");
   }
   public void useMessenger(TextMessenger messenger) {
      messenger.send("I'm TextMessenger for sure, but?");
   }
}
```

So what do you think will happen when I try to invoke *Demo.useMessenger* with a *TextMessenger*. If your language doesn't support true multiple dispatch mechanism, you'll always end up invoking *useMessenger(Messenger)* function no matter what you provide. With true multiple dispatching, you'll invoke *useMessenger(TextMessenger)* when you provide TextMessenger to the function. More information **Multiple Dispatch** or **Multiple Dispatch**. BTW, Java doesn't support true multiple dispatching, so don't cause any bugs while creating overloaded methods.

### Double Dispatching

Well this one is pretty cool. In real world, all relations are actually two-way. It's not only you're telling somebody about something, he/she is also listening to you and not somebody else at that moment. Double dispatching is also like this - two-way. Visitor pattern is actually good way of explaining this topic. Let's look at the following example:

```java
// messenger
interface Messenger {
   void send(Message message);
}
class TextMessenger implements Messenger {
   public void send(Message message) {
      // some custom operations
      message.print(this);
   }
}
class XMLMessenger implements Messenger {
   public void send(Message message) {
      // some other custom operations
      message.print(this);
   }
}
// and message
class Message {
    public void print(TextMessenger messenger) {
      // do something
    }
    public void print(XMLMessenger messenger) {
      // do some other thing
    }
}
```

As you can easily see, objects are related to each-other both ways. Message is deciding to do something based on other types. Again, for more information you can refer **Double Dispatching** definition.

Hope this clarifies things a bit more.

1. http://en.wikipedia.org/wiki/Monkey_patch
1. http://en.wikipedia.org/wiki/Duck_typing
1. http://en.wikipedia.org/wiki/Single_dispatch#Single_and_multiple_dispatch
1. http://c2.com/cgi/wiki?SingleDispatch
1. http://c2.com/cgi/wiki?DynamicDispatch
1. http://en.wikipedia.org/wiki/Multiple_dispatch
1. http://c2.com/cgi/wiki?MultipleDispatch
1. http://en.wikipedia.org/wiki/Double_dispatch
