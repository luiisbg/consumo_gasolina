# ServiceFlow

**ServiceFlow App** es una aplicación en Flutter diseñada para gestionar y calcular el consumo de gasolina de una flotilla de vehículos técnicos, que se dedican a reparar fibra óptica en zonas afectadas. La app permite a los usuarios capturar una foto del odómetro junto con la ubicación GPS actual, calculando así el consumo de combustible con base en los datos obtenidos. El valor de consumo predeterminado es de **10 km/l**, pero puede ser modificado.

## Características

- **Captura de fotos del odómetro**: Permite a los técnicos tomar fotos del odómetro de los vehículos.
- **Ubicación GPS**: Guarda la ubicación (latitud y longitud) en el momento en que se captura la foto.
- **Ubicación GPS**: Muestra los diferentes servicios que tiene asignado un técnico para que acuda a atenderlos y finalizarlos.


## Requisitos

### 1. Flutter
Es necesario tener instalado Flutter. Puedes seguir las instrucciones de instalación en: [Flutter - Get Started](https://flutter.dev/docs/get-started/install).

### 1. MySQL
Es necesario crear un backend en una base de datos MySQL para el almacenamiento de los usuarios:
--CREATE TABLE LecturaOdometro (
    Id INT(11) AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT(11),
    Fecha DATETIME,
    Foto TEXT,
    CONSTRAINT fk_lectura_usuario FOREIGN KEY (IdUsuario) REFERENCES usuarios(Id)
);
--CREATE TABLE Servicios (
    Id INT(11) AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE,
    Tipo VARCHAR(50),
    Zona VARCHAR(50),
    Alcaldia VARCHAR(50),
    Colonia VARCHAR(50),
    Prioridad VARCHAR(50),
    Status INT(11),
    HoraAtendido DATETIME,
    HoraFinalizado TIMESTAMP,
    HoraCreacion TIMESTAMP,
    NumeroCuenta VARCHAR(50),
    UsuarioId INT(11),
    GPS_Inicio VARCHAR(50),
    GPS_Final VARCHAR(50),
    CONSTRAINT fk_servicios_usuario FOREIGN KEY (UsuarioId) REFERENCES usuarios(Id)
);
--CREATE TABLE usuarios (
    Id INT(11) AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(255),
    Password VARCHAR(255),
    NombreUsuario VARCHAR(60)
);

