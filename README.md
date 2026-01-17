# Automation of Deployment and Configuration of a Web Application Environment on the AWS Platform 
### Terraform & Ansible – Infrastructure as Code / Configuration as Code

## Streszczenie

Celem pracy było zaprojektowanie oraz implementacja **zautomatyzowanego procesu wdrażania aplikacji webowej w chmurze Amazon Web Services (AWS)**, obejmującego zarówno tworzenie infrastruktury, jak i konfigurację środowiska aplikacyjnego. Opracowane rozwiązanie stanowi **parametryzowany szablon infrastruktury**, umożliwiający szybkie, powtarzalne i spójne wdrażanie środowisk bez konieczności ręcznej konfiguracji zasobów.

W ramach pracy wykorzystano narzędzie **Terraform**, realizujące podejście *Infrastructure as Code (IaC)*, odpowiedzialne za automatyczne tworzenie warstwy sieciowej, mechanizmów bezpieczeństwa oraz kluczowych komponentów infrastruktury chmurowej, takich jak:

- Virtual Private Cloud (VPC),
- Security Groups,
- Application Load Balancer (ALB),
- Auto Scaling Groups (ASG),
- relacyjna baza danych **Amazon RDS**.

Konfiguracja instancji Amazon EC2 została zrealizowana przy użyciu narzędzia **Ansible**, implementującego podejście *Configuration as Code (CaC)*. Ansible odpowiadał za instalację wymaganych usług, wdrożenie kodu aplikacji oraz konfigurację serwerów frontendowych i backendowych w sposób w pełni automatyczny.

W ramach projektu wdrożono **przykładową aplikację webową**, która posłużyła do weryfikacji poprawności działania zaprojektowanej infrastruktury oraz całego procesu automatycznego wdrażania. Uzyskane rezultaty potwierdziły skuteczność zastosowanego podejścia oraz możliwość jego wykorzystania jako uniwersalnego szablonu wdrożeniowego dla aplikacji webowych w środowisku chmurowym.

## Wykorzystane technologie

- **Amazon Web Services (AWS)**
- **Terraform** - Infrastructure as Code
- **Ansible** - Configuration as Code
- **EC2, ALB, ASG, RDS, VPC**
- **Linux - ubuntu**
