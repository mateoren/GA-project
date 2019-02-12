# Genetic Algorithm for Tensor Completion

This is a Macaulay2 implementation of a genetic algorithm for finding the smallest partial tensor (of a given size) that is completable to a rank-one tensor. In other words, it finds the smallest number of entries along with their distribution that allow rank-one completion of the partial tensor

## Motivation

In my previous work regarding tensor completion I implemented an algorithm for deciding completability that, given a size and number of entries, generated all possible tensors and classified those that are completable and in this way it is possible to find the partial tensor with minimum number of entries that is completable. However, generating all tensors becomes intractable for tensors of larger size. Therefore, a genetic algorithm proves useful for finding the partial tensor with minimum number of entries that is completable, for partial tensors of larger size. 

## Usage

It suffices to define the tensor size and the parameters of the genetic algorithm

## Author 

Mateo Rendon Jaramillo.
