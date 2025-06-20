@REQ_COD-0001  @apiCOD-0001
Feature: apiCOD-0001

Background:
* def urlApi = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'

@id:1 @obtenerPersonajesExitoso
Scenario Outline: T-API-PREQ_COD-0001-CA1- Obetenr lista de personajes
Given url urlApi
When method GET
Then status 200
* print response
Examples:
| dummy |
| 1     |

@id:2 @obtenerPersonajesEstructuraExitoso
Scenario: T-API-PREQ_COD-0001-CA2 - Obtener lista de personajes con estructura adecuada exitosamente
Given url urlApi
When method GET
Then status 200
And match response == '#[]'
And match each response contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }
And assert response.length > 0
* print 'Total de personajes encontrados:', response.length

@id:3 @validarEstructuraRespuesta 
Scenario: T-API-PREQ_COD-0001-CA3 - Validar estructura de respuesta de personajes
Given url urlApi
When method GET
Then status 200
And match response[0] contains
"""
{
  id: '#number',
  name: '#string',
  alterego: '#string', 
  description: '#string',
  powers: '#array'
}
"""
And match response[0].powers == '#[]'
And assert response[0].id != null
And assert response[0].name != ''
And assert response[0].alterego != ''

@id:4 @validarCamposObligatorios 
Scenario: T-API-PREQ_COD-0001-CA4 - Validar campos obligatorios en respuesta
Given url urlApi
When method GET
Then status 200
And match response[0].id == '#number'
And match response[0].name == '#string'
And match response[0].alterego == '#string'
And match response[0].description == '#string'
And match response[0].powers == '#array'
* print 'Validación de campos exitosa'

@id:5 @endpointInexistente 
Scenario: T-API-PREQ_COD-0001-CA5 - Endpoint inexistente debe retornar error
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters-invalid'
When method GET
Then status 500
And match response contains { error: '#string' }
* print 'Error esperado:', response

@id:7 @methodNotAllowed 
Scenario: T-API-PREQ_COD-0001-CA7 - Método POST no permitido en GET endpoint
Given url urlApi
When method POST
Then status 500
And match response contains { error: '#string' }
* print 'Status code obtenido:', responseStatus
* print 'Método POST correctamente rechazado con error 500'

@id:8 @methodNotAllowed 
Scenario: T-API-PREQ_COD-0001-CA7 - Método PUT no permitido en GET endpoint
Given url urlApi
When method PUT
Then status 500
And match response contains { error: '#string' }
* print 'Status code obtenido:', responseStatus
* print 'Método PUT correctamente rechazado con error 500'

@id:9 @methodNotAllowed
Scenario: T-API-PREQ_COD-0001-CA9 - Método DELETE no permitido en GET endpoint
Given url urlApi
When method DELETE
Then status 500
And match response contains { error: '#string' }
* print 'Status code obtenido:', responseStatus
* print 'Método DELETE correctamente rechazado con error 500'

@id:10 @obtenerPersonajePorIdExitoso
Scenario: T-API-PREQ_COD-0001-CA10 - Obtener personaje por ID exitosamente
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/800'
When method GET
Then status 200
And match response contains
"""
{
  id: '#number',
  name: '#string',
  alterego: '#string', 
  description: '#string',
  powers: '#array'
}
"""
And assert response.id == 800
And assert response.name != null
And assert response.alterego != null
And assert response.description != null
And assert response.powers.length > 0
* print 'Personaje encontrado:', response.name
* print 'Alter ego:', response.alterego
* print 'Poderes:', response.powers

@id:11 @obtenerPersonajePorIdInexistente
Scenario: T-API-PREQ_COD-0001-CA11 - Obtener personaje por ID inexistente debe retornar 404
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999'
When method GET
Then status 404
And match response contains { error: '#string' }
And match response.error == 'Character not found'
* print 'Error esperado para ID inexistente:', response.error
* print 'Status code correcto: 404 Not Found'

@id:12 @crearPersonajeExitoso
Scenario: T-API-PREQ_COD-0001-CA12 - Crear personaje exitosamente con POST
Given url urlApi
* def timestamp = new java.util.Date().getTime()
* def uniqueName = 'Iron Man Test ' + timestamp
And request
"""
{
  "name": "#(uniqueName)",
  "alterego": "Tony Stark",
  "description": "Genius billionaire",
  "powers": ["Armor", "Flight"]
}
"""
When method POST
Then status 201
And match response contains
"""
{
  id: '#number',
  name: '#(uniqueName)',
  alterego: 'Tony Stark',
  description: 'Genius billionaire',
  powers: ['Armor', 'Flight']
}
"""
And assert response.id != null
* print 'Personaje creado exitosamente con ID:', response.id
* print 'Nombre:', response.name
* print 'Alter ego:', response.alterego

@id:13 @crearPersonajeNombreDuplicado
Scenario: T-API-PREQ_COD-0001-CA13 - Error al crear personaje con nombre duplicado
Given url urlApi
And request
"""
{
  "name": "Iron Man",
  "alterego": "Otro",
  "description": "Otro",
  "powers": ["Armor"]
}
"""
When method POST
Then status 400
And match response contains { error: '#string' }
And match response.error == 'Character name already exists'
* print 'Error esperado por nombre duplicado:', response.error
* print 'Status code correcto: 400 Bad Request'

@id:14 @crearPersonajeCamposFaltantes
Scenario: T-API-PREQ_COD-0001-CA14 - Error al crear personaje con campos faltantes
Given url urlApi
And request
"""
{
  "name": "",
  "alterego": "",
  "description": "",
  "powers": []
}
"""
When method POST
Then status 400
And match response contains { name: '#string', alterego: '#string', description: '#string', powers: '#string' }
And match response.name == 'Name is required'
And match response.alterego == 'Alterego is required'
And match response.description == 'Description is required'
And match response.powers == 'Powers are required'
* print 'Errores de validación esperados:'
* print 'Name:', response.name
* print 'Alterego:', response.alterego
* print 'Description:', response.description
* print 'Powers:', response.powers

@id:15 @actualizarPersonajeExitoso
Scenario: T-API-PREQ_COD-0001-CA15 - Actualizar personaje exitosamente con PUT
* def timestamp = new java.util.Date().getTime()
* def updatedDescription = 'Updated description ' + timestamp
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/800'
And request
"""
{
  "name": "Iron Man",
  "alterego": "Tony Stark",
  "description": "#(updatedDescription)",
  "powers": ["Armor", "Flight"]
}
"""
When method PUT
Then status 200
And match response contains
"""
{
  id: 800,
  name: 'Iron Man',
  alterego: 'Tony Stark',
  description: '#(updatedDescription)',
  powers: ['Armor', 'Flight']
}
"""
And assert response.id == 800
* print 'Personaje actualizado exitosamente:'
* print 'ID:', response.id
* print 'Nombre:', response.name
* print 'Descripción actualizada:', response.description

@id:16 @actualizarPersonajeInexistente
Scenario: T-API-PREQ_COD-0001-CA16 - Error al actualizar personaje que no existe
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999'
And request
"""
{
  "name": "Iron Man",
  "alterego": "Tony Stark",
  "description": "Updated description",
  "powers": ["Armor", "Flight"]
}
"""
When method PUT
Then status 404
And match response contains { error: '#string' }
And match response.error == 'Character not found'
* print 'Error esperado para ID inexistente:', response.error
* print 'Status code correcto: 404 Not Found'

@id:17 @eliminarPersonajeExitoso
Scenario: T-API-PREQ_COD-0001-CA17 - Eliminar personaje exitosamente con DELETE
# creamos un personaje para eliminar
Given url urlApi
And request
"""
{
  "name": "Character to Delete Test",
  "alterego": "Delete Test",
  "description": "Character created to be deleted",
  "powers": ["Delete Power"]
}
"""
When method POST
Then status 201
* def createdId = response.id
* print 'Personaje creado con ID:', createdId

# Ahora eliminamos el personaje creado
Given url urlApi + '/' + createdId
When method DELETE
Then status 204
* print 'Personaje eliminado exitosamente, ID:', createdId

# Verificamos que ya no existe
Given url urlApi + '/' + createdId
When method GET
Then status 404
And match response contains { error: '#string' }
* print 'Confirmado: Personaje ya no existe después de DELETE'


@id:18 @eliminarPersonajeInexistente
Scenario: T-API-PREQ_COD-0001-CA18 - Error al eliminar personaje que no existe
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/999'
When method DELETE
Then status 404
And match response contains { error: '#string' }
And match response.error == 'Character not found'
* print 'Error esperado para ID inexistente:', response.error
* print 'Status code correcto: 404 Not Found'


