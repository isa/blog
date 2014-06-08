---
title: "Act Like a Senior Developer - About Clean Code"
layout: "post"
isPost: true
date: "12-25-2009"
headline: "machine2.png"
urls:
   - /2009/act-like-a-senior-developer
   - /2009/development/agile-development/act-like-a-senior-developer-about-clean-code
tags:
   - agile
   - clean-code
   - professional
   - java
   - programming
---

# Act Like a Senior Developer

## Today it was a hard day for me. As usual, I was looking at a mess around our code base. And the worst thing was that the code that I saw today was not a legacy code:S

The code I was dealing today had enough test coverage and moreover the system was working well. The problem was the conditional logics used all over the place. It is almost impossible to follow what's happening and where :S Me and my colleague spent 2 whole days trying to understand what the heck was going on. Finally we figured it out and did what we wanted to do initially.

Here, I wanna just stop and speak loudly to all the developers that call themselves senior or principal or if (experience != Experiences.JUNIOR):

People, what's wrong with us? How come newly implemented code base is turning into a mess this fast? How come we're allowing such a mess when we see it slowly approaching us like a monster? But of course, when it comes to the interviews, we have to ask candidates questions around design patterns, real-time problem solving skills, test driven design, and refactoring. And seriously is this why we were asking these questions? I'm so emberassed and ashamed of being a senior guy today.

Anyways, long story short, here is a 5 minute crash course about what we forget to foresee:

### Evil Ifs

As a senior guy, you have to be aware of ifs are evil in most cases. For those who forgot, here is a quick do not forget list:

#### Allow them when:

Condition can be expressed without AND, OR operators: i.e

```java
if (myContainer.hasItems()) {
   //...
}
```

Condition is about an encapsulated field: i.e

```java
if (_isVisible) {
      //...
}
```

Condition is non-float numerical comparison: i.e

```java
if (myCertificates.count() > 3) {
      //...
}
```

#### Be cautious:

When there is one or two _AND_, _OR_ operators: i.e

```java
if (_isVisible && !isParent) {
   //...
}
// SOLUTION: refactor (extract method, extract local variable, etc)
```

When there is negative logic: i.e

```java
if (!_iAmSenior) {
   //...
}
// SOLUTION: refactor (make it positive like iAmJunior;
// positive statements are easy to understand)
```

When there is a very long condition: i.e

```java
if (myAwesomeServiceImpl.findExtremelyImportantSomething()
                               .equals(myLocalExtremelyImportantThing)) {
      //...
}
// SOLUTION: refactor (make it short or extract local variable,
// trust me your application is not at the point where you should
// worry about memory or CPU cycles)
```

When there is a if/else statement: i.e

```java
if (_isVisible) {
   number = getNumberFromMoon();
} else {
   number = 1;
}
// this creates more than 2 execution paths within one method,
// make sure you force all the possibilities to block above logic
// SOLUTION: get rid of the second part if possible as in:
number = 1;
if (_isVisible) {
   number = getNumberFromMoon();
}
// if it is not this simple, then make sure you created
// two different executions paths (with different
// methods/classes) before coming to this point
```

#### Don't allow please

When it is a null check:

```java
if (item != null) {
   // do something...
}
// SOLUTION: find the cause of null and eliminate it.
```

For more information on this topic, please read my previous post about [Null Pointer Exceptions](/2009/how-to-avoid-null-pointer-exceptions).

When there is more than two AND, OR, NOT operators: i.e

```java
if ((_isVisible && !isParent) || iAmMaster || youCanPassIsSet) {
   // do something...
}
// SOLUTION: For God's sake! you have to refactor this code.
// The least you can do is extracting a method out of it
// if you don't know any design patterns to apply. Check below:
if (isValid()) {
   // do something...
}
```

When there is nested if/else statement: i.e

```java
if (isThisTrue) {
   if (checkIfHeIsTheMaster() && !hmmmThisSeemsWeird()) {
      // do something...
   } else {
      // do something else...
   }
} else {
   // this is just ugly...
}
// SOLUTION: Use well known OOP technique called *POLYMORPHISM*,
// or if the operator is one of (>, <, ==) then various possible
// design patterns like Strategy (behavior modification),
// Visitor (context evaluation) or Specification (item selection).
// If you're not happy, but you don't know what to do then talk
// to someone you think he/she might know.
```

Also if you are the maintainer of the code base then you might wanna introduce static code analyzers like PMD. They can easily detect cyclomatic complexities.

Anyways, you guys can easily figure it out. You are welcome to introduce new ones. These are just some that I can think of in the middle of the night.

### Stupid Loops

Folks, if you're introducing loops to your logic, please make sure that you really need them. Please check the code snippets and the solutions below; I don't wanna comment more about this:

```java
for (int i=0; i < 2; i++) {
   if (i == 0) {
      doThis();
   } else if (i == 1) {
      doThat();
   }
}
// SOLUTION: how about this? You don't need loop there :S
doThis();
doThat();
```

One more:

```java
item = null;
for (int i=0; i < items.size(); i++) {
   if (isVisible(items.get(i))) {
      item = items.get(i);
   }
}
return item;
// SOLUTION: how about this? returning values directly?
for (int i=0; i < items.size(); i++) {
   if (isVisible(items.get(i))) { // EDIT from user comments
      return items.get(i);
   }
}
return null; // if possible even return new NullItem()
```

And please.. Very pretty please, stay the frick away from the nested loops. I don't wanna even talk about it.

### Dependency Injections

Woov, this one is an advanced topic ah? Everyone loves dependency injection. Spring sort of frameworks are even forcing you to do it this way right? Let me tell you something; I believe after go-to statements, this one is the most misinterpreted topic in programming history. We senior guys somehow convinced ourselves to something like this:

> If you can inject it's cost free!

Man... just don't do this please. Everything has a cost. This is just a way to ease/loose your tight connections with your dependencies. Don't try to interpret otherwise.

And second thing is the famous setter injection. So if you have a setter injection set up there, it means don't worry. It's like we can't think otherwise :S Opppss. Stop here! It is not like that at all if you still couldn't figure it out. Setter injection and Constructor injection are 2 well known ways of doing this (there are other ways too). Each of them has its own advantages/disadvantages. However, let's be honest. Constructor injection is much more declarative than setter injection.

Anyways, it'a very big debate. I'm kinda scared :P People are gonna be offended again. I just wanna say that if possible please try to use constructor injection in your custom code. If you don't believe me, then refer to Martin Fowler's **IOC Article** or Misko Hevery's *Clean Code* talks at Google, such as **Don't Look For Things**.

### So Many Dependencies

Just a tiny comment here. Folks, try reading **SOLID** principles, ok. DON'T CREATE this much dependency :S The class itself is screaming at you:

> I can't carry this much! You won't be able to test this, I've more than 1000 lines, You can't use constructor injection anymore!

Bottom line, if you have so many dependencies, please try to find a way to separate concerns.

### So Many Parameters

You have more than 3-4 arguments? Re-consider that code. Probably you don't need that. I'm sure you can pull up something from that method or at least extract and call separately.

### Pass What You Need

This bugs me a lot. Look at this:

```java
calculateLoanForSomething(Account, Customer, World);
// here is the method
void calculateLoanForSomething(Account a, Customer c, World w) {
   if (w.date.time.hour == 11) {
      // do something here..
   }
}
// Why r u sending God objects everywhere :S
void calculateLoanForSomething(Account a, Customer c, int hour) { }
```

### Long Classes/Methods

Here is my rule of thumb:

* Is it more than 20 lines? Refactor
* Is it more than 10 methods? Refactor
* Is it more than 5 package? Refactor
* Your colleague is coding? Please pair with him/her as much as you can especially if you think he/she is gonna introduce something bad. At least you can teach him/her or prevent things from happening.

I don't know if you guys are agree with me or not. I was so ashamed today and wanted to write this. It was more like a self relaxation. Please don't mind if I used a wrong sentence or anything. It's almost 2AM and I'm so tired.

For more deeper information about these topics, please refer to Refactoring Book or **site**, **SOLID Principles**, Clean Code **talks**, Clean Code **book**.

1. http://martinfowler.com/articles/injection.html#ConstructorInjectionWithPicocontainer
1. http://www.youtube.com/watch?v=RlfLCWKxHJ0
1. http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)
1. http://refactoring.com
1. http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)
1. http://www.youtube.com/watch?v=RlfLCWKxHJ0&list=PL693EFD059797C21E
1. http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882
