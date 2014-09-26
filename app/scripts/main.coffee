containerTemplate = Handlebars.compile('''
<div class="manager-container">
    <div class="left">
        <ul class="api-list"></ul>
    </div>
    <div class="right">
    </div>
</div>
''')

apiNavTemplate = Handlebars.compile('''
<li class="api-nav-item">
    <a href="#" data-id="{{ resourceId }}">{{ collectionName }}</a>
</li>
''')

apiDetailsTemplate = Handlebars.compile('''
<h1>{{ title }} ({{ collectionName }})</h1>
<h2>Supported Indexes</h2>
<ul class="api-index-list">
{{#each indexes }}
    <li class="api-index">
        <h3>{{@key}}</h3>
    </li>
{{/each}}
</ul>

<h2>Collection Properties</h2>
<ul class="api-index-list">
{{#each properties }}
    <li class="api-property">
        <h3>{{@key}}</h3>
    </li>
{{/each}}
</ul>

''')


class ApiManager
    constructor: (@element, @options) ->
        defaults =
            backstageDataUrl: 'http://localhost:5000'
            schemasEndpoint: '/api/item-schemas'

        @options = $.extend({}, defaults, @options)

        @gatherElements()
        @bindEvents()
        @loadData()

    gatherElements: ->
        @elements =
            container: $(containerTemplate({}))

        @elements.apiList = @elements.container.find('.api-list')
        @elements.rightContainer = @elements.container.find('.right')
        @element.append(@elements.container)

    bindEvents: ->
        @element.on('click', '.api-nav-item a', (ev) =>
            ev.preventDefault()
            item = $(ev.currentTarget)
            itemId = item.attr('data-id')
            itemData = @schemas[itemId]
            console.log(itemData)
            @elements.rightContainer.html(apiDetailsTemplate(itemData))
        )

    loadData: ->
        $.ajax(
            dataType: "json"
            url: @options.backstageDataUrl + @options.schemasEndpoint
            success: (data) =>
                @schemas = {}
                for item in data.items
                    @schemas[item.resourceId] = item
                    @elements.apiList.append(apiNavTemplate(item))
        )

window.LoopbackManager = window.LoopbackManager || {}
window.LoopbackManager.ApiManager = ApiManager
