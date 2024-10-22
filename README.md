# Simulación de Sistemas Distribuidos
## Basado en el algoritmo de Raft
### README

Este archivo explica el funcionamiento y cómo ejecutar la simulación de Sistemas Distribuidos.

* Ruby version
  ```
  ruby 3.3.5
  ```

* Instrucciones para levantar el servicio
  ```
  rails s
  redis-server
  bundle exec sidekiq
  ```

### Explicación del funcionamiento

* Creación de un nodo
  ```
  Node.create( )
  ```
  > Cada Nodo es creado con valores por default, es decir, el estado de cada Nodo inicia como FOLLOWER,
  > otros tipos de estado que puede tener el Nodo son: CANDIDATE y LEADER

* Elección del lider
  * Ejecución del Job
    
    > Mediante un after_save alojado en el modelo Node, se ejecuta un job justo después de crear la instancia:
    ```
    def init_node
      ActiveNodeJob.perform_async(self.id, 0)
    end
    ```
    > Dicho job se ejecuta de forma asíncrona, por lo que cada Nodo ejecutará su propio Job que no irán uno detrás de otro sino a la par

  * Convertirse en candidato

    > El Job espera constantemente una señal del líder, en caso de no haberla en un tiempo establecido, el nodo se postula como candidato
    ```
    @node.requests_votes()
    ```
    > Este método cambia el estado del nodo, a CANDIDATO y envía un REQUEST_VOTE al resto de los nodos, y cada uno de los nodos que resibieron
    > el request, responden votando por el nodo que lo solicitó.

  * Elegir entre los candidatos

    > Es posible que más de un nodo se haya postulado como candidato, cada nodo candidato recibirá una cantidad de votos y aquel que tenga más
    > será elegido como lider.

    > En caso de que dos candidatos obtengan la misma cantidad de votos, continuarán enviando solicitudes de votos al resto de los nodos hasta
    > que se tome una decisión entre todos.

   * Asignar nuevo lider
    ```
    @node.change_leader
    ```
     > Una vez que se ha elegido el nuevo lider, se ejecuta el código anterior para cambiar el status a LEADER y cambiar el status de cada
     > candidato de nuevo a FOLLOWER.
    
* Funcionamiento normal del líder

  > El líder enviará periódicamente señales a sus FOLLOWERS, tales señales quedarán almacenadas como un log en cada Nodo FOLLOWER.
  ```
  @node.notify_all_followers
  ```
    
