# Technical decision about using Contracts

Contract is a layer that helps us to validate the input before performing an Use Case.

In Clean Architecture, every use case receives an input, transforms it and returns an output that is the input transformed by all the steps of the process.

Keeping the validations separated is a decision that helps the Use Case code to be cleaner, focusing only on the steps defined by the Business because the input was already validated according to the Use Case expectation.

## Entity validations x Contracts

From one point of view it looks like we are repeating validations that are already present in the entity, but one thing is having rules that are part of persistence and another is to having rules necessary for a use case to be performed. The concept is different and having these things separated can increase the code maintainability in a long term.

Maybe some of these rules are the same, but others could be different and specific for some use cases.

## Motivation

When I was working with Ruby and I started to implement Use Cases using a Clean Architecture approach, my first use cases was getting bigger and a little messy because the first steps of the Use Case was always steps to validate a lot of things before even start to do the processing.

It was a common thing to have different validations for different use cases and all these validations was being made at the Use Case code or at the persistence layer with a lot of ifs and elses.

Clean Architecture is just a concept, and this concept is more about the mindset of how to develop things than about specific language implementations. This means that contracts are not an specific concept from clean architecture, but a layer that can complement this vision/mindset.

At the time, I studied some alternatives and found a Ruby framework that was doing something great to solve the issue. The framework was [trailblazer](https://github.com/trailblazer/trailblazer) and the contract layer implemented by this project is heavily inspired by trailbalzer's contracts.

Working at Betterfly, I helped my leader (Bruno Silva) to write a blog post about the use of clean architecture with Elixir and contracts. The post describes better the motivation behind it. You can read it [here](https://medium.com/betterfly-tech/clean-architecture-input-validation-with-elixir-b1a076210942).

## The challenge

I believe that for this challenge maybe the use of contracts are a little over engineering, but I got used to using this type of structure in all my long term projects and I have had good results in the medium and long term.

Depending on the project I would do something simplier, but as this is a challenge I chose to show a little more structured code.
