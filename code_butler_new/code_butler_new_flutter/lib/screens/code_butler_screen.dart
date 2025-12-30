import 'package:flutter/material.dart';
import '../main.dart';

class CodeButlerScreen extends StatefulWidget {
  const CodeButlerScreen({super.key});

  @override
  State<CodeButlerScreen> createState() => _CodeButlerScreenState();
}

class _CodeButlerScreenState extends State<CodeButlerScreen> {
  final _repoNameController = TextEditingController(text: 'test-repo');
  final _repoUrlController = TextEditingController(text: 'https://github.com/testuser/test-repo.git');
  final _repoOwnerController = TextEditingController(text: 'testuser');
  final _prNumberController = TextEditingController(text: '1');
  final _prTitleController = TextEditingController(text: 'Test PR for Code Butler');

  String? _statusMessage;
  String? _errorMessage;
  bool _isLoading = false;
  List<Map<String, dynamic>> _repositories = [];
  List<Map<String, dynamic>> _pullRequests = [];

  @override
  void initState() {
    super.initState();
    _loadRepositories();
  }

  Future<void> _loadRepositories() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final repos = await client.repository.listRepositories();
      setState(() {
        _repositories = repos.map((r) => {
          'id': r.id,
          'name': r.name,
          'url': r.url,
          'owner': r.owner,
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading repositories: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createRepository() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _statusMessage = null;
      });

      final repo = await client.repository.createRepository(
        _repoNameController.text,
        _repoUrlController.text,
        _repoOwnerController.text,
        'main',
      );

      setState(() {
        _statusMessage = 'Repository created: ${repo.name} (ID: ${repo.id})';
        _isLoading = false;
      });

      _loadRepositories();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating repository: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createPullRequest(int repositoryId) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _statusMessage = null;
      });

      final pr = await client.pullRequest.createPullRequest(
        repositoryId,
        int.parse(_prNumberController.text),
        _prTitleController.text,
        'main',
        'feature-branch',
        5,
      );

      setState(() {
        _statusMessage = 'Pull Request created: ${pr.title} (ID: ${pr.id})';
        _isLoading = false;
      });

      _loadPullRequests(repositoryId);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating pull request: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPullRequests(int repositoryId) async {
    try {
      final prs = await client.pullRequest.listPullRequests(repositoryId);
      setState(() {
        _pullRequests = prs.map((pr) => {
          'id': pr.id,
          'prNumber': pr.prNumber,
          'title': pr.title,
          'status': pr.status,
        }).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading pull requests: $e';
      });
    }
  }

  Future<void> _startReview(int pullRequestId) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _statusMessage = null;
      });

      final reviewSession = await client.review.startReview(pullRequestId);

      setState(() {
        _statusMessage = 'Review started! Session ID: ${reviewSession.id}, Status: ${reviewSession.status}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error starting review: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Butler Demo'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Messages
            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Create Repository Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create Repository',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _repoNameController,
                      decoration: const InputDecoration(
                        labelText: 'Repository Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _repoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Repository URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _repoOwnerController,
                      decoration: const InputDecoration(
                        labelText: 'Owner',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createRepository,
                      child: const Text('Create Repository'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Repositories List
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Repositories',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _loadRepositories,
                        ),
                      ],
                    ),
                    if (_repositories.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No repositories found'),
                      )
                    else
                      ..._repositories.map((repo) => ListTile(
                            title: Text(repo['name']),
                            subtitle: Text('${repo['owner']} - ${repo['url']}'),
                            trailing: ElevatedButton(
                              onPressed: () => _loadPullRequests(repo['id']),
                              child: const Text('View PRs'),
                            ),
                          )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Create Pull Request Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create Pull Request',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (_repositories.isNotEmpty) ...[
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Repository',
                          border: OutlineInputBorder(),
                        ),
                        items: _repositories.map((repo) {
                          return DropdownMenuItem<int>(
                            value: repo['id'],
                            child: Text(repo['name']),
                          );
                        }).toList(),
                        onChanged: (repoId) {
                          if (repoId != null) {
                            _loadPullRequests(repoId);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: _prNumberController,
                      decoration: const InputDecoration(
                        labelText: 'PR Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _prTitleController,
                      decoration: const InputDecoration(
                        labelText: 'PR Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading || _repositories.isEmpty
                          ? null
                          : () => _createPullRequest(_repositories.first['id']),
                      child: const Text('Create Pull Request'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pull Requests List
            if (_pullRequests.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Pull Requests',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ..._pullRequests.map((pr) => ListTile(
                            title: Text('PR #${pr['prNumber']}: ${pr['title']}'),
                            subtitle: Text('Status: ${pr['status']}'),
                            trailing: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _startReview(pr['id']),
                              child: const Text('Start Review'),
                            ),
                          )),
                    ],
                  ),
                ),
              ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _repoNameController.dispose();
    _repoUrlController.dispose();
    _repoOwnerController.dispose();
    _prNumberController.dispose();
    _prTitleController.dispose();
    super.dispose();
  }
}

