# ServiceFlow

**ServiceFlow App** es una aplicación en Flutter diseñada para gestionar y calcular el consumo de gasolina de una flotilla de vehículos técnicos, que se dedican a reparar fibra óptica en zonas afectadas. La app permite a los usuarios capturar una foto del odómetro junto con la ubicación GPS actual, calculando así el consumo de combustible con base en los datos obtenidos. El valor de consumo predeterminado es de **10 km/l**, pero puede ser modificado.

## Características

- **Captura de fotos del odómetro**: Permite a los técnicos tomar fotos del odómetro de los vehículos.
- **Ubicación GPS**: Guarda la ubicación (latitud y longitud) en el momento en que se captura la foto.
- **Gestión de servicios**: Muestra los diferentes servicios que tiene asignado un técnico para que acuda a atenderlos y finalizarlos.

## Requisitos

### 1. Flutter
Es necesario tener instalado Flutter. Puedes seguir las instrucciones de instalación en: [Flutter - Get Started](https://flutter.dev/docs/get-started/install).

### 2. MySQL
Es necesario crear un backend en una base de datos MySQL para el almacenamiento de los usuarios.

#### Tablas

- **LecturaOdometro**: Tabla para almacenar las lecturas del odómetro.
  
  ```sql
  CREATE TABLE LecturaOdometro (
    Id INT(11) AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada lectura.
    IdUsuario INT(11),                     -- Identificador del usuario asociado a la lectura.
    Fecha DATETIME,                         -- Fecha y hora de la lectura.
    Foto TEXT,                              -- Ruta o datos de la foto asociada a la lectura.
    CONSTRAINT fk_lectura_usuario FOREIGN KEY (IdUsuario) REFERENCES usuarios(Id) -- Relación con la tabla de usuarios.
  );

- **Servicios**: Tabla para almacenar los servicios.
  
  ```sql
  CREATE TABLE Servicios (
  Id INT(11) AUTO_INCREMENT PRIMARY KEY, -- Identificador único para cada servicio.
  Fecha DATE,                             -- Fecha del servicio.
  Tipo VARCHAR(50),                       -- Tipo de servicio.
  Zona VARCHAR(50),                       -- Zona donde se presta el servicio.
  Alcaldia VARCHAR(50),                   -- Alcaldía correspondiente.
  Colonia VARCHAR(50),                    -- Colonia donde se realiza el servicio.
  Prioridad VARCHAR(50),                  -- Prioridad del servicio.
  Status INT(11),                         -- Estado actual del servicio.
  HoraAtendido DATETIME,                  -- Hora en que se atendió el servicio.
  HoraFinalizado TIMESTAMP,               -- Hora en que se finalizó el servicio.
  HoraCreacion TIMESTAMP,                 -- Hora en que se creó el registro del servicio.
  NumeroCuenta VARCHAR(50),               -- Número de cuenta del usuario.
  UsuarioId INT(11),                     -- Identificador del usuario que solicita el servicio.
  GPS_Inicio VARCHAR(50),                 -- Coordenadas GPS de inicio.
  GPS_Final VARCHAR(50),                  -- Coordenadas GPS de finalización.
  CONSTRAINT fk_servicios_usuario FOREIGN KEY (UsuarioId) REFERENCES usuarios(Id) -- Relación con la tabla de usuarios.
  );

- **Usuarios**: Tabla para almacenar la información de los usuarios.
  ```sql
  CREATE TABLE usuarios (
  Id INT(11) AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada usuario.
  UserName VARCHAR(255),                   -- Nombre de usuario único.
  Password VARCHAR(255),                    -- Contraseña del usuario.
  NombreUsuario VARCHAR(60)                 -- Nombre completo del usuario.
  );

**Nota**: Es necesario modificar la calidad de la foto para que salga nítida ya que por default está en un 10% de su tamaño, y de igual forma en la base de datos cambiar a VARCHAR(MAX). 