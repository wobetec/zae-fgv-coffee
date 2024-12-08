import 'package:flutter/material.dart';

import 'components/user_info_card.dart';
import 'constants.dart';
import 'reports_page.dart';
import 'home_page.dart';

import 'package:namer_app/apis/apis.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String supportName = 'Support';

  @override
  void initState() {
    super.initState();
    _loadPageDetail();
  }

  Future<void> _loadPageDetail() async {
    APIs apis = APIs();
    setState(() {
      supportName = apis.auth.getUsername()!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: appBarTextStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Cabeçalho indicando o papel do usuário
          ProfileHeader(title: 'Admin'),
          // Cartão com informações do perfil
          UserInfoCard(
            username: supportName,
            textColor: textColor,
            cardColor: Color(0xFFE2E2E2),
          ),
          Expanded(child: OptionList()),
        ],
      ),
    );
  }
}

// Componente para o cabeçalho
class ProfileHeader extends StatelessWidget {
  final String title;

  const ProfileHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      width: double.infinity,
      child: Text(
        title,
        style: headerTextStyle,
      ),
    );
  }
}

// Componente para o cartão de perfil
class ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const ProfileCard({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Placeholder para a imagem do perfil
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.account_circle,
              size: 70,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 16),
          // Nome e Email do Administrador
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: profileNameTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: profileEmailTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Componente para a lista de opções
class OptionList extends StatelessWidget {
  const OptionList({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        OptionListTile(
          title: 'Reports',
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsPage()),
            );
          },
        ),
        Divider(),
        OptionListTile(
          leading: Icon(Icons.logout, color: textColor),
          title: 'Sign Out',
          onTap: () async {
            try {
              APIs().logout();
            } catch (e) {
              print('Failed to logout. Please try again.');
              return;
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
        ),
        Divider(),
      ],
    );
  }
}

// Componente personalizado para os itens da lista de opções
class OptionListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;

  const OptionListTile({
    Key? key,
    required this.title,
    required this.onTap,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: optionTextStyle,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
