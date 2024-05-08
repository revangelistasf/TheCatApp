# TheCatApp
It's an iOS application developed in Swift, to fetch a list of cat breeds from [TheCatAPI](https://thecatapi.com/) and displays then, and be able to save them as favorites, to have them offline.

## Summary
 - [Problem Description](#problem-description)
 - [Solution](#solution)
 - [Prerequisites](#prerequisites)
 - [Trade-offs](#trade-offs)
 - [Improvements](improvements)
 
## Problem Description
An application using Swift, that utilises [TheCatAPI](https://thecatapi.com/) to fetch a list of cat breeds.
- An create a screen listing the cat breeds with the image, and breed name, with a search bar to filter the list by breed name.
- The cat breed screen should contain a button to mark breeds as favorites.
- A screen that show the breeds marked as favorites, and on this one showing de average life span of that breed.
- A screen to show details of that breed.
Creating this using MVVM architecture, SwiftUI, UnitTests, and Offline Functionality.

## Solution
- Using Swift Concurrency(async await) to retrieve information from API using a repository structure to inject even Network Service and Persistence Service to have one source of data.
- A state management of ViewModel to control the SwiftUI View state through ObservableObject
- Core data to save Favorite breeds offline
- Pagination from the Breed List View to make request 10 by 10
- Error factory view to create views based on throwable errors
- Create a small structure to make requests just creating new `Endpoints`

## Prerequisites
- iPhone or Simulator running iOS 16.0 or later
- Xcode 14.0 or later

## Trade-offs
- Pagination: API didn't inform the page number, or total items, to prevent make useless requests due the infinity scrolling, I've set a validation `state.isLoadingNextPage, result.isEmpty` and create a variable `didReachLastPage` to control.
- Breeds List: due to time and the scope of the project I decided to update the views to request the breeds whenever the screen is opened 
- Simplified UI: Create simple cards to present the data, they're quite simple but giving the user a good experience. Don't have an iPad version
- Dependency Injection: I chose to set some defaults implementations for dependency injection instead creating DI container to control this.

## Improvements
- Navigate using UIKit stack though UIHostViewController and create a Router or Coordinators to navigate in the app and control better the Dependency Injection.
- Favorites View update, instead of make refresh on the entire view, create an better structure to update only the changed card view maybe using the `NotificationCenter` though `NSManagedObjectContextObjectsDidChange` to notificate view model the cell new objects and update the UI
- Pull to refresh on BreedList
- iPad support
- Create my own version of AsyncImage, instead of using NukeUI 
