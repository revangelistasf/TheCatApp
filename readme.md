# TheCatApp


## Decisions
### Breed List
- API didn't inform the page number, or total items, to prevent make useless requests due the infinity scrolling, I've set a validation `state.isLoadingNextPage, result.isEmpty` and create a variable `didReachLastPage` to control.
