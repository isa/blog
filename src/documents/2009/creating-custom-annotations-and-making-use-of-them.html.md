---
title: "Creating Custom Annotations and Making Use of Them"
layout: "post"
isPost: true
date: "10-07-2009"
headline: "random1.png"
urls:
   - /2009/creating-custom-annotations-and-making-use-of-them
   - /2009/development/java/creating-custom-annotations-and-making-use-of-them
tags:
   - java
   - annotation
   - programming
   - processing
---

# Creating Custom Annotations and Using Them

## Okay, here is another topic that I couldn't find much information on the net :) So I guess I'm gonna cover it very quickly.

### How to Create a Custom Annotations?

There are a lot of documentation about this part in the Internet. All you have to do is basically creating an annotation class like below:

```java
public @interface Copyright {
   String info() default "";
}
```

And that's it. Now it's ready to use! Now you can put copyright information to your classes :) Since we didn't define any **@Target** , you can use this annotation anywhere in your classes by default. If you want your annotation to be only available for class-wise or method-wise, you should define @Target annotation. Here is a little table of what **ElementType** options are available:

* *ElementType.PACKAGE:* package header
* *ElementType.TYPE:* class header
* *ElementType.CONSTRUCTOR:* constructor header
* *ElementType.METHOD:* method header
* *ElementType.FIELD:* for class fields only
* *ElementType.PARAMATER:* for method parameters only
* *ElementType.LOCAL_VARIABLE:* for local variables only

If you want your annotation to be available in more than one place, just use array syntax as in:

```java
@Target({ ElementType.PARAMETER, ElementType.LOCAL_VARIABLE })
```

One thing you may already notice is annotations are interfaces, so you don't implement anything in them.

### How to Make Use of Your Custom Annotations?

Up to here, you can find lots of examples. Okaaay, now let's do something useful :) For instance, let's re-implement JUnit's @Test annotation. As you guys already know, @Test annotation is a marker annotation. Basically it marks the method as test method. If you're expecting any exceptions, you would set expect attribute in the annotation. You can try anything here, I'm just using this example since everyone knows how @Test annotation works.

First let's define our annotation:

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
   Class expected();
}
```

You might notice that I used **@Retention**. This annotation marks our annotation to be retained by JVM at runtime. This will allow us to use Java reflections later on.

Now we need to write our annotation parser class. This class will parse our annotation and trigger some other invocations related to what we want. Keep in mind that if you have more than one custom annotation, then it's also wise to have separate parsers for each annotation you define. So I'll create one for this! The basic idea behind the annotation parser is using Java reflections to access the annotation information/attributes etc. So here is an example parser for our @Test annotation:

```java
public class TestAnnotationParser {
   public void parse(Class<?> clazz) throws Exception {
      Method[] methods = clazz.getMethods();
      int pass = 0;
      int fail = 0;
      for (Method method : methods) {
         if (method.isAnnotationPresent(Test.class)) {
            try {
               method.invoke(null);
               pass++;
            } catch (Exception e) {
               fail++;
            }
         }
      }
   }
}
```

That's all you need. You parser is ready to use too. But wait a minute we didn't implement anything about the annotation attributes. This part is a bit tricky. Because you cannot directly access those attributes from the object graph. Luckily invocation helps us here. You can only access these attributes by invoking them. Sometimes you might need to cast the class to the annotation type too. I'm sure you'll figure out when you see it:) Anyways here is a bit more logic to take our expected attribute into account:

```java
// ...
// this is how you access to the attributes
Test test = method.getAnnotation(Test.class);
// we use Class type here because our attribute type
// is class. If it would be string, you'd use string
Class expected = test.expected();
try {
   method.invoke(null);
   pass++;
} catch (Exception e) {
   if (Exception.class != expected) {
       fail++;
   } else {
       pass++;
   }
}
// ...
```

Now everything is ready to use. Below example demonstrates how you use Parser with your test classes:

```java
public class Demo {
   public static void main(String [] args) {
      TestAnnotationParser parser = new TestAnnotationParser();
      parser.parse(MyTest.class);
      // you can use also Class.forName
      // to load from file system directly!
   }
}
```

Yeah, I hope you enjoyed. Don't hesitate to shoot me an email if you've a better approach? Thanks! Here is the full parser class implementation:

```java
public class TestAnnotationParser {
   public void parse(Class<?> clazz) throws Exception {
      Method[] methods = clazz.getMethods();
      int pass = 0;
      int fail = 0;
      for (Method method : methods) {
         if (method.isAnnotationPresent(Test.class)) {
            // this is how you access to the attributes
            Test test = method.getAnnotation(Test.class);
            Class expected = test.expected();
            try {
               method.invoke(null);
               pass++;
            } catch (Exception e) {
               if (Exception.class != expected) {
                  fail++;
               } else {
                  pass++;
               }
            }
         }
      }
   }
}
```

*Edit: Also after receiving some emails, I guess I should add a full working example :) So here is one. Just copy paste and run the show :)*

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@interface Test {
   String info() default "";
}
class Annotated {
   @Test(info = "AWESOME")
   public void foo(String myParam) {
      System.out.println("This is " + myParam);
   }
}
class TestAnnotationParser {
   public void parse(Class> clazz) throws Exception {
      Method[] methods = clazz.getMethods();
      for (Method method : methods) {
         if (method.isAnnotationPresent(Test.class)) {
            Test test = method.getAnnotation(Test.class);
            String info = test.info();
            if ("AWESOME".equals(info)) {
                System.out.println("info is awesome!");
                // try to invoke the method with param
                method.invoke(
                   Annotated.class.newInstance(),
                   info
                );
            }
         }
      }
   }
}
public class Demo {
   public static void main(String[] args) throws Exception {
      TestAnnotationParser parser = new TestAnnotationParser();
      parser.parse(Annotated.class);
   }
}
```

1. http://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Target.html
1. http://docs.oracle.com/javase/8/docs/api/java/lang/annotation/ElementType.html
1. http://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Retention.html
