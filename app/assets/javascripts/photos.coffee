# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  Dropzone.options.myDropzone =
    acceptedFiles: 'image/*, .pdf, .csv'
    dictCancelUpload: 'Cancel Upload'
    dictRemoveFile: 'Remove file'
    dictInvalidFileType: 'invalid file'
    paramName: 'photo[file]'
    maxFilesize: 5
    addRemoveLinks: true
    init: ->
      thisDropzone = this
      $.getJSON 'photos.json', (data) ->
        $.each data, (index, val) ->
          mockFile =
            name: val.name
            size: val.size
            pid: val.pid

          thisDropzone.options.addedfile.call thisDropzone, mockFile
          thisDropzone.options.thumbnail.call thisDropzone, mockFile, val.url
          $('#myDropzone .dz-preview').last().attr('data-pid', val.pid)
          return
        return
      return
    sending: (file, xhr) ->
      $.rails.CSRFProtection(xhr)
    success: (file, response) ->
      file.pid = response.pid
      $('#myDropzone .dz-preview').last().attr('data-pid', val.pid)
    removedfile: (file) ->
      return if file.pid and !confirm('Are you sure?')
      $.ajax
        url: "photos/#{file.pid}"
        type: 'DELETE'
        success: (result) ->
          $(file.previewElement).remove() if (result.success is true)
          return


  $('#myDropzone').sortable
    items: '.dz-preview'
    cursor: 'move'
    opacity: 0.5
    distance: 20
    tolerance: 'pointer'
    stop: (event, ui) ->
      positions = {}
      $('#myDropzone .dz-preview').each (index)->
        pid = $(this).data('pid')
        positions[pid] = index

      $.post 'photos/update_position',
        {positions: positions}, (data) ->
          true
        , 'json'
      return
