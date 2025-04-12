allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Yeni build dizini yapılandırması
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Bağımlılıkların yüklenmesi için app modülüne başvurulması sağlanır
subprojects {
    project.evaluationDependsOn(":app")
}

// Temizlik işlemi için görev kaydederiz
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
