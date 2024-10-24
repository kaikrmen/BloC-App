import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'package:flutter_blog_app/screens/post_detail_screen.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 600, // Altura máxima para limitar el tamaño de la card
        minHeight: 150, // Altura mínima si es necesario
      ),
      child: Card(
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes redondeados
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Asegura que el contenido se ajuste
            children: [
              // Sección superior (Etiqueta como "Community")
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 5, 63, 171),
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Text(
                  'User ID: ${widget.post.userId}', // UserId como la etiqueta superior
                  style: const TextStyle(
                    color:
                        Color.fromARGB(221, 255, 255, 255), // Color del texto
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Título del post
              Text(
                widget.post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Texto del cuerpo del post
              Text(
                widget.post.body,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // "Read more" y el botón de flecha que lleva a los detalles
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Alinear el botón hacia la izquierda
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(post: widget.post),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Colors.blue, // Color azul para el texto y el icono
                      padding: EdgeInsets
                          .zero, // Quitar el padding para que se vea más compacto
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Row(
                      children: [
                        Text('Read more'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Imagen con indicador de carga
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Proporción 16:9 para evitar overflow
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(post: widget.post),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://fastly.picsum.photos/id/93/2000/1334.jpg?hmac=HdhcVTbAYkFCXsu1qBRWeEPiy05Qjc3LbnMWJlfEFjo',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
