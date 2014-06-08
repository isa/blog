---
title: "How to Avoid NullPointerExceptions (NPE)?"
layout: "post"
isPost: true
date: "05-04-2009"
headline: "lady1.png"
urls:
   - /2009/development/java/how-to-avoid-nullpointerexceptions-npe
   - /2009/how-to-avoid-null-pointer-exceptions
tags:
   - agile
   - null-pointer
   - handling
   - error
   - professional
   - java
   - programming
---

# How to Avoid NullPointerExceptions?

I am sure every Java developer has had some hard times with null pointer exceptions since Java doesn't really have a nice mechanism to avoid them :) Let's recall something here: NPE is a run time exception and it occurs in the run time, therefore it means it is a design mistake, bad code quality or careless programming. Anyways, whatever the reason is, we all see NPEs all over our codes :) In this post, I want to cover this issue and give some tips from my experience so far.

### Why NPE?

And from Java spec perspective, I don't know why they never came up with something nice so far. And I hate it, 'coz Java spec doesn't contain anything for this. Luckily there are some proposals for Java 7 like **@NotNull** and @Nullable annotations and ? syntax.

### How to Avoid?

Avoiding NPE for a legacy code is very challenging since legacy code doesn't contain any Unit Tests that covers it. For an on-going development, I'll try to explain some best practices. If it is applicable for your code-base, just try it. You won't regret :) A quick side note: all these are my experiences so far and it might not be applicable for all scenarios. However, I'm sure you'll find a likely approach for your code base.

Here is my agenda for this post:

* @NotNull and @Nullable annotations from IntelliJ,
* A friend of Java developers: assertions,
* Factory Pattern,
* Accurate Exception Handling
* Common Practices
* Unit Testing
* Aspect Oriented Programming
* Null Object Pattern

### @NotNull and @Nullable Annotations

I love IntelliJ. I think, it's the best Java IDE in the market. It has a little cost, but believe me it is worth it. You can argue about this, but before trying the IntelliJ for yourself, your arguments will be just irrelevant for me :) Anyway, let's get back to topic :)

@NotNull and @Nullable are life-saver annotations and designed to help you watch contracts throughout method hierarchy. Consequently this will avoid emergence of NPEs. With these tiny annotations, you can save a lot of time. Let's look at the usage of these annotations:

```java
@Nullable
private String getDefinition() {
   // ...
}

public void doSomething() {
   if (getDefinition().equals("DEFINITION")) {
      // ...
   }

   // ...
}
```

When you try to invoke a @Nullable method (in this case it's getDefinition), you'll receive a warning that says: "getDefinition may product NPE". Now you know that you have to check for NPE. Isn't that nice? Now let's look at the @NotNull annotation's usage:

```java
private User findUser(@NotNull final String id) {
   // ...
}

public void doSomething() {
   // try invoking with null parameter
   User user = findUser(null);

   // ...
}
```

If you try to invoke the findUser method with @NotNull, you'll receive a warning that says: "Passing 'null' argument to a method annotated @NotNull". By using these annotations, it's almost impossible to receive an NPE from your code base (I ignored the 3rd party tools).

As you see, these are really nice annotations. However, the bad news is that they're not really friendly if you're not using IntelliJ. For more information about these annotations, please look at the how-to documentation.

So what are other options to avoid NPEs? Just continue reading.. :)

### Java Assertions

Java introduced assert keyword with Java 1.4, but the interesting thing about them is no one is really using it or they don't even know what it is. I think we're giving up a very nice feature by not using them. So what is this assertion thing?

An assertion is a statement that enables you to test your assumptions about your code. For example, if you write a method that returns the quantity of products in the system, you might assert that the returning quantity should be greater than or equal to 0. Basic usage of assertions would be:

```java
assert <Expression>; // or another usage is
assert <Expression1> : <Expression2>;
```

For more information about assertions, please look at the Sun's **assertion guide**.

So far it's okay, but how are we gonna use it to avoid NPEs? Very simple. There are two ways to use assertions in your code base:

First, direct usage. Please check the following code:

```java
public void getUserDetails(final User user) {
   // make sure that user is not null

   assert (user != null) : "User cannot be null";
}
```

Second way of using assertions is creating an *Assert* utility class as in **Spring**. You can put various assertions into this utility class for your project like *isEmpty()*, *isValidCountryCode()*, etc.

```java
public void doSomethingWithUser(final User user) {
   // make sure that user is not null

   Assert.notNull(user, "User cannot be null");
   Assert.hasLength(user.getLastName(), "User must have a last name");

   // etc..
}
```

I want to highlight one thing here. Assertions should be available only in the development process, and not in the production environment. And one more thing, you shouldn't use any business logic with the assert keyword. Otherwise when assertions are gone after development, your code doesn't work.

### Factory Pattern

Factory Pattern is a design pattern that is used to create concrete objects. The idea is preventing developers to have their own object creation and initialization (I10N) code within various part of the project. By using factory pattern, you would have a centralized object creation and initialization, and you would prevent mis-initialization problems. For more information about the pattern, please check Gang of Four's official **design patterns page**.

Now let's look at how to use this method to avoid NPEs. Please look at the following example:

```java
public void doSomething() {
   // ...

   myPrettyService.save(dummyObject);
}
```

At first look, it seems like there is no problem in the code. However, careful eyes can catch that *myPrettyService* might not be initialized at all. This is one common problem of using services/DAOs or any external provider's instance. Yes it might be null. To prevent this, people tend to create a Singleton of these services. We all know that Singletons are evil in most cases (there are exceptions). To avoid NPE and Singleton together, factory pattern saves us :) Please check the following code:

```java
public void doSomething() {
   // ...

   ServiceFactory.getMyPrettyService().save(dummyObject);
}
```

I'll post another article about *Singleton* and *Factory* patterns later on. For now, just imagine that *ServiceFactory* returns only a single instance of our service every time we invoke it (a little singleton hint is by using reflection and making service's constructor private).

### Accurate Exception Handling

One common mistake is not throwing exceptions. I think the reason is that people find try-catch blocks ugly. However, they're also life-savers, especially pin-pointing the problematic areas in your code-base. Right now, probably you're thinking what's the relation between avoiding NPEs and throwing exceptions. Let me tell you why accurate exception handling is important. First, look at the following code snippet:

```java
public User findByGuid(final String guid) {
   // ...

   Result result = executeNamedQuery(FIND_BY_GUID);

   if (!result.isEmpty()) { // EDIT from comments
      return result.get(0);
   }

   return null;
}
```

As you see, our guy is trying to reach the *User* by querying the database and returning the result, if there is any, otherwise it returns null. You see this kind of code everywhere, maybe even you're coding just like this. Maybe you think nothing is wrong with this code. Let me tell what is wrong with this code snippet. Since this method is public, anyone can invoke it. People who use this method might forget to null check for the result, especially if our guy is not a good documenter :S (java developers tend to forget JavaDocs I don't know why :P). As in following code:

```java
public void doSomething() {
   // ...

   User user = service.findByGuid("XYZ");
   String licenseNumber = user.getLicenseCode().getEncryptedLicenseNumber();

   // ...
}
```

Unfortunately, this usage seems perfect, but it throws NPE at run-time :( And then you would try to understand what's wrong with your code. After finding that this user is null, like most developers you tend to place a quick & dirty fix as below:

```java
public void doSomething() {
   // ...

   User user = service.findByGuid("XYZ");

   if (user != null) {
      String licenseNumber = user.getLicenseCode().getEncryptedLicenseNumber();
   }

   // ...
}
```

I guess now we're on the same page. If this guy would have thrown an exception instead of returning null, you would never end up with an NPE. Instead of throwing an accurate exception, now you're struggling with an NPE. From this point, I'm leaving it to your considerations:

```java
public User findByGuid(final String guid) throws UserNotFoundException {
   // ...

   Result result = executeNamedQuery(FIND_BY_GUID);

   if (result.isEmpty()) {
      return result.get(0);
   }

   throw UserNotFoundException("No user found with guid: %1$s", guid); // or any ServiceException you like..
}
```

### Common Practices

This part contains some common patterns/practices for your NPE safety. I'll give some bad code samples and correct them. Please compare each code snippets to have good understanding of why it is a common practice.

#### 1. NPE on String

Don't compare Strings like below:

```java
public void doSomething() {
   // ...

   if (name.equals("BAD")) {
      // do something
   }

   // ...
}
```

instead do like this:

```java
public void doSomething() {
   // ...

   if ("BAD".equals(name)) {
      // do something
   }

   // ...
}
```

#### 2. Empty Collections

Don't return null from your service methods like below:

```java
public List<User> getUsers() {
   // ...

   Result result = executeNamedQuery(GET_ALL_USERS);

   if (result.isEmpty()) {
      return result;
   }

   return null;
}
```

instead do like this:

```java
public List<User> getUsers() {
   // ...

   Result result = executeNamedQuery(GET_ALL_USERS);

   if (result.isEmpty()) {
      return result;
   }

   return Collections.EMPTY_LIST; // or EMPTY_SET or EMPTY_MAP, etc. Depending on your return type
}
```

#### 3. Too Many Dot Syntax

If your object is not a builder object, don't use too many dot syntax in your code like below:

```java
public void doSomething() {
   // ...

   user.getCountry().findStateByCode("BC").getPopulation();

   // ...
}
instead do like this:
public void doSomething() {
   // ...

   Number population = getStatePopulationFromUser(user);

   // ...
}

private Number getStatePopulationFromUser(final User user) {
   Country country = user.getCountry();
   State state = country.findStateByCode("BC");

   return state.getPopulation();
}
```

#### 4. Use contains(), containsKey(), containsValue()

Try to use collection's *contains()*, *containsKey()* and *containsValue()* methods. Don't do like this:

```java
public void doSomething() {
   // ...

   TaxCode taxCodeForTurkey = taxCodeMap.get("Turkey");

   // ...
}
```

instead do like this:

```java
public void doSomething() {
   // ...

   if (taxCodeMap.containsKey("Turkey")) {
      TaxCode taxCodeForTurkey = taxCodeMap.get("Turkey");
   }

   // ...
}
```

### Unit Testing

This should be a default action for an agile developer. If you discover an NPE in your code, please update your *Unit Tests*. And of course before having this problem, make sure that your Unit is already covered for NPEs :P

### Aspect Oriented Programming
This is a really big topic. So I'll cut it short. Try to look at *Aspect Oriented Programming*. By using AOP, you might have some neat way of handling NPEs (by inserting if (object == null ) { handleNull(); } kinda logic into your bytecode).

### Null Object Pattern

Martin Fowler's Refactoring **book** covers this topic very nice. However I find it very un-practical. Then again, it's wise to have a quick look on this pattern. The basic idea of pattern is creating a Null version of your possible error-prone objects.

That's it folks. I'm sure you guys have your own experiences about NPEs too. Please help me to grow this post. Just shoot me an email if you have other ways of dealing with NPEs..

1. http://docs.oracle.com/javase/8/docs/api/java/lang/NullPointerException.html
1. https://www.jetbrains.com/idea/documentation/howto.html
1. http://docs.oracle.com/javase/8/docs/technotes/guides/language/assert.html
1. http://projects.spring.io/spring-framework/
1. http://www.dofactory.com/Patterns/Patterns.aspx
1. http://refactoring.com/catalog/introduceNullObject.html
