define [
  'i18n!react_files'
  'react'
  'compiled/react/shared/utils/withReactDOM'
  'compiled/fn/preventDefault'
  '../modules/customPropTypes'
  '../modules/filesEnv'
  'compiled/models/Folder'
  './RestrictedDialogForm'
  '../utils/openMoveDialog'
  '../utils/downloadStuffAsAZip'
  '../utils/deleteStuff'
  'jquery'
  'jqueryui/dialog'
], (I18n, React, withReactDOM, preventDefault, customPropTypes, filesEnv, Folder, RestrictedDialogForm, openMoveDialog, downloadStuffAsAZip, deleteStuff, $) ->

  ItemCog = React.createClass
    displayName: 'ItemCog'

    propTypes:
      model: customPropTypes.filesystemObject

    render: withReactDOM ->
      wrap = (fn) =>
        preventDefault (event) =>
          singularContextType = @props.model.collection?.parentFolder?.get('context_type').toLowerCase()
          pluralContextType = singularContextType + 's' if singularContextType?
          contextType = pluralContextType || filesEnv.contextType
          contextId = @props.model.collection?.parentFolder?.get('context_id') || filesEnv.contextId
          fn([@props.model], {
            contextType: contextType
            contextId: contextId
            returnFocusTo: @refs.settingsCogBtn.getDOMNode()
          })

      span {},

        button {
          type: 'button'
          ref: 'settingsCogBtn'
          className: 'al-trigger al-trigger-gray btn btn-link'
          'aria-label': I18n.t('settings', 'Settings')
          'data-popup-within' : "#wrapper"
          'data-append-to-body' : true
        },
          i className:'icon-settings',
          i className:'icon-mini-arrow-down'

        ul className:'al-options',
          li {},
            a (if @props.model instanceof Folder
              href: '#'
              onClick: wrap(downloadStuffAsAZip)
              ref: 'download'
            else
              href: @props.model.get('url')
              ref: 'download'
            ),
              I18n.t('download', 'Download')
          if @props.userCanManageFilesForContext
            [
              li {},
                a {
                  href:'#'
                  onClick: preventDefault(@props.startEditingName)
                  ref: 'editName'
                },
                  I18n.t('edit_name', 'Edit Name')
              li {},
                a {
                  href:'#'
                  onClick: wrap(openMoveDialog)
                  ref: 'move'
                },
                  I18n.t('move', 'Move')
              li {},
                a {
                  href:'#'
                  onClick: wrap(deleteStuff)
                  ref: 'deleteLink'
                },
                  I18n.t('delete', 'Delete')
            ]
