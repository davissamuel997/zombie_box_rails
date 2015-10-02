zombieBox.controller 'PostsController', ['$scope', '$http', 'PostsService', '$location', '$pusher', '$sce', ($scope, $http, PostsService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getPosts()

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

    current_page: 1

    pagination: null

    post_params: {

      text: null

      title: null

    }

    posts: []

    returnKeyValue: 13 # charCode for pressing enter

    scopedPostIndex: null

    changePage: (page_number) ->
      this.current_page = page_number
      this.getPosts()

    checkLikeLinkColor: (boolean) ->
      if boolean && boolean == true then return null else return 'make-black'

    createPostComment: (post) ->
      if post.newComment && post.newComment.length > 0 && post.post_id && post.post_id > 0
        PostsService.createPostComment.query({ post_id: post.post_id, comment_text: post.newComment }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.posts[$scope.requestControl.scopedPostIndex].comments = responseData.comments

            $scope.requestControl.scopedPostIndex = null      
        )

    createPost: ->
      if this.post_params
        PostsService.createPost.query({ post_params: this.post_params }, (responseData) -> 
          if responseData.errors == false
            $scope.requestControl.resetPostParams()

            $scope.requestControl.current_page = 1
            $scope.requestControl.posts = responseData.data.posts
            $scope.requestControl.pagination = responseData.data.pagination
        )

    eventKeypress: ($event, postIndex) ->
      # If the key pressed was enter
      if $event.charCode == this.returnKeyValue
        this.scopedPostIndex = postIndex

        this.createPostComment($scope.requestControl.posts[this.scopedPostIndex])

    getPosts: ->
      PostsService.getPosts.query({}, (responseData) -> 
        if responseData.errors == false
          $scope.requestControl.posts = responseData.posts
          $scope.requestControl.pagination = responseData.pagination
      )

    likePost: (postIndex) ->
      this.scopedPostIndex = postIndex

      post = this.posts[this.scopedPostIndex]

      if post.post_id && post.post_id > 0
        PostsService.likePost.query({ post_id: post.post_id }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.posts[$scope.requestControl.scopedPostIndex] = responseData.post

            $scope.requestControl.scopedPostIndex = null
        )

    resetPostParams: ->
      this.post_params.text = null
      this.post_params.title = null

    unLikePost: (postIndex) ->
      this.scopedPostIndex = postIndex

      post = this.posts[this.scopedPostIndex]

      if post.post_id && post.post_id > 0
        PostsService.unLikePost.query({ post_id: post.post_id }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.posts[$scope.requestControl.scopedPostIndex] = responseData.post

            $scope.requestControl.scopedPostIndex = null
        )
  }

################################################################
################# Initialize ###################################

  init()


]
