FROM ghcr.io/cirruslabs/flutter:3.29.3

WORKDIR /app

COPY pubspec.* ./

RUN flutter pub get

COPY . .

RUN flutter build apk --release

CMD ["ls", "-l", "/app/build/app/outputs/flutter-apk/"]

