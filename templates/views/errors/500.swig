{% extends "../../layouts/default.swig" %}

{% block content %}
	<div class="container">
		<h1>{{ statusCode }}</h1>
    
        {% if statusCode == 403 %}
        <p class="lead">Forbidden</p>
        <p>If this error seems unfounded, try updating the page.</p>
        {% else %}
        <p class="lead">An unexpected internal server error occured.</p>
        {% endif %}		
    
        {% if error %}
        <pre class="alert alert-danger">{{ error }}</pre>
        {% if stacktrace %}
        <pre>{{ stacktrace }}</pre>
        {% endif %}
        {% endif %}
    
        <p>Go back <a href="/neuvontajono">to the front page</a>.</p>
        
	</div>
{% endblock %}
